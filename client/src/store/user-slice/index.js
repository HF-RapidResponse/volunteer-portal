import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';
import { AccountCreateReqBody, AccountBody, SettingsReqBody } from './classes';
import {
  validatePassword,
  validateEmail,
  validateAlphaNumericUnicode,
  validatePassRetype,
  validateZipCode,
  validateUsername,
  sanitizeData,
  formHasNoErrors,
  handleRegisterErrors,
  handlePossibleExpiredToken,
} from './helpers';

const userSlice = createSlice({
  name: 'userStore',

  initialState: {
    user: null,
    firstAcctPage: null,
    tokenRefreshTime: null,
    initLoading: false,
    subscriptions: [],
  },

  reducers: {
    setUser: (state, action) => {
      const { payload } = action;
      state.user = payload;
    },
    setRefreshTime: (state, action) => {
      const { payload } = action;
      state.tokenRefreshTime = payload;
    },
    completeLogout: (state) => {
      state.user = null;
      state.firstAcctPage = null;
      state.tokenRefreshTime = null;
      state.initLoading = false;
    },
    setFirstAcctPage: (state, action) => {
      const { payload } = action;
      state.firstAcctPage = payload;
    },
    completeDelete: (state, action) => {
      const { payload } = action;
      state.user.roles = state.user.roles.filter((element) => {
        return element != payload;
      });
    },
    setInitLoading: (state, action) => {
      const { payload } = action;
      state.initLoading = payload;
    },
  },
});

export const {
  setUser,
  setRefreshTime,
  completeLogout,
  setFirstAcctPage,
  completeDelete,
  setInitLoading,
} = userSlice.actions;

export const attemptLogin = (payload) => async (dispatch) => {
  const { email, password } = payload;
  const errors = {
    email: validateEmail(email),
    password: validatePassword(password),
  };
  try {
    if (formHasNoErrors(errors)) {
      sanitizeData(payload);
      const accountRes = await axios.post(`/api/auth/basic`, payload);
      const accountData = accountRes.data;
      if (accountData) {
        const refreshTime = Date.now();
        dispatch(setRefreshTime(refreshTime));
        const settings = await getSettings(accountData.uuid);
        const user = { ...accountData, ...settings };
        dispatch(setUser(user));
        return;
      }
    }
  } catch (error) {
    console.error(error);
    errors.api = error.response.data.detail;
  }
  throw errors;
};

const getSettings = async (id) => {
  if (!id) {
    throw 'missing required id param';
  }

  try {
    const settingsRes = await axios.get(`/api/account_settings/${id}`);
    const initMapRes = await axios.get(
      `/api/subscriptions/account/${id}/initiative_map`
    );
    const settings = settingsRes.data;
    const initiativeMap = initMapRes.data;
    if (settings && initiativeMap) {
      settings.initiative_map = await updateInitiativeMap(initiativeMap);
    }
    return settings;
  } catch (error) {
    console.error(error);
  }
};

export const updateInitiativeMap = async (payload) => {
  const initiative_map = payload ?? {};
  const updatedMap = {};

  try {
    const initiativeResponse = await axios.get(`/api/initiatives/`);
    const initiatives = initiativeResponse.data;

    if (initiatives) {
      initiatives.forEach((item) => {
        updatedMap[item.initiative_name] =
          initiative_map[item.initiative_name] ?? false;
      });
    }
    return updatedMap;
  } catch {
    console.error('error while attempting to update initiative map');
    return initiative_map;
  }
};

export const checkIfCookieIsValid = (cookies) => async (dispatch) => {
  try {
    const cookieID = cookies.get('user_id');
    const refreshTime = await refreshAccessToken();
    dispatch(setRefreshTime(refreshTime));
    const getUserRes = await axios.get(`/api/accounts/${cookieID}`);
    const user = getUserRes.data;
    if (!user) {
      throw 'invalid user from cookies';
    }
  } catch (error) {
    console.error(error);
    cookies.remove('user_id', { path: '/', sameSite: 'None', secure: true });
    window.location.reload();
  }
};

export const syncInitMapAndLoadUser = (id) => async (dispatch) => {
  try {
    dispatch(setInitLoading(true));
    const refreshTime = await refreshAccessToken();
    dispatch(setRefreshTime(refreshTime));
    const acctRes = await axios.get(`/api/accounts/${id}`);
    const settings = await getSettings(id);
    const user = {
      ...acctRes.data,
      ...settings,
    };
    dispatch(setUser(user));
  } catch (error) {
    console.error(error);
  } finally {
    dispatch(setInitLoading(false));
  }
};

const refreshAccessToken = async () => {
  try {
    await axios.post(`/api/refresh`);
    const refreshTime = Date.now();
    return refreshTime;
  } catch (error) {
    console.error(error);
  }
};

const refreshTokenIfNeeded = (tokenRefreshTime) => async (dispatch) => {
  const currTime = Date.now();
  const timeDiff = currTime - tokenRefreshTime;

  if (!tokenRefreshTime || timeDiff > 750000) {
    const newRefreshTime = await refreshAccessToken();
    dispatch(setRefreshTime(newRefreshTime));
  }
};

export const startLogout = (cookies) => async (dispatch) => {
  try {
    await refreshAccessToken();
    await axios.delete(`/api/logout`);
    cookies.remove('user_id', {
      path: '/',
      sameSite: 'none',
      secure: true,
    });
    dispatch(completeLogout());
  } catch (error) {
    console.error(error);
  }
};

export const loadLoggedInUser = (payload) => (dispatch) => {
  dispatch(setUser(payload));
};

export const attemptRegister = (payload) => async (dispatch) => {
  if (!payload) {
    throw { detail: 'empty register payload' };
  }

  const errors = {
    firstName: validateAlphaNumericUnicode(payload.first_name),
    lastName:
      payload.last_name && payload.last_name.trim()
        ? validateAlphaNumericUnicode(payload.last_name)
        : null,
    username: validateUsername(payload.username),
    email: validateEmail(payload.email),
    password: validatePassword(payload.password),
    retypePass: validatePassRetype(payload.password, payload.retypePass),
  };

  if (!formHasNoErrors(errors)) {
    throw errors;
  }

  try {
    sanitizeData(payload);
    const request = {
      account: payload,
      identifier: { identifier: payload.email, type: 'email' },
      password: payload.password,
    };

    const objPayload = new AccountCreateReqBody(request);
    const accountRes = await axios.post(`/api/accounts/`, objPayload);
    const createdAcct = accountRes.data;
    if (createdAcct) {
      const obj = {
        account_uuid: createdAcct.uuid,
        identifier: createdAcct.email,
        type: 'email',
      };
      await axios.post(`/api/verify_identifier/start`, obj);
    }
  } catch (error) {
    handleRegisterErrors(error.response, errors);
    throw errors;
  }
};

export const attemptChangePassword = (payload) => async (dispatch) => {
  const { uuid, oldPass, newPass, retypePass, tokenRefreshTime } = payload;
  const errors = {
    oldPassInvalid: validatePassword(oldPass),
    newPassRetypeMismatch: validatePassRetype(newPass, retypePass),
    newPassInvalid: validatePassword(newPass),
  };

  try {
    const acctReqObj = {
      old_password: oldPass,
      uuid: uuid,
    };
    dispatch(refreshTokenIfNeeded(tokenRefreshTime));
    const oldPassIsValid = await axios.post(`/api/verify_password`, acctReqObj);

    if (oldPassIsValid.data && formHasNoErrors(errors)) {
      const accountRes = await axios.patch(`/api/accounts/${uuid}`, {
        password: newPass,
      });

      const settings = await getSettings(uuid);
      const userCopy = { ...accountRes.data, ...settings };
      dispatch(setUser(userCopy));
      return;
    }
  } catch (error) {
    errors.oldPassInvalid = true;
    handlePossibleExpiredToken(error);
  }
  throw errors;
};

export const deleteRole = (payload) => async (dispatch) => {
  dispatch(completeDelete(payload));
};

export const deleteUser = (uuid, cookies) => async (dispatch) => {
  try {
    await refreshAccessToken();
    await axios.delete(`/api/accounts/${uuid}`);
    cookies.remove('user_id', { path: '/', sameSite: 'None', secure: true });
  } catch (error) {
    console.error(error);
  } finally {
    dispatch(completeLogout());
  }
};

export const basicPropUpdate = (payload) => async (dispatch) => {
  const { user, key, newVal, tokenRefreshTime } = payload;
  let userCopy = { ...user };
  userCopy[key] = newVal;
  try {
    dispatch(refreshTokenIfNeeded(tokenRefreshTime));
    const settingsReq = new SettingsReqBody(userCopy);
    const response = await axios.put(
      `/api/account_settings/${settingsReq.uuid}`,
      settingsReq
    );
    userCopy = { ...userCopy, ...response.data };
    dispatch(setUser(userCopy));
  } catch (error) {
    console.error(error);
    handlePossibleExpiredToken(error);
  }
};

export const toggleInitiativeSubscription = (payload) => async (dispatch) => {
  const {
    user,
    uuid,
    initiative_name,
    willSubscribe,
    tokenRefreshTime,
  } = payload;
  const userCopy = { ...user };
  userCopy.initiative_map = {
    ...userCopy.initiative_map,
  };
  userCopy.initiative_map[initiative_name] = willSubscribe;
  try {
    dispatch(refreshTokenIfNeeded(tokenRefreshTime));
    if (willSubscribe) {
      const subscribeReqObj = {
        entity_type: 'initiative',
        entity_uuid: uuid,
        identifier: {
          identifier: user.email,
          type: 'email',
        },
      };
      await axios.post(`/api/subscriptions/subscribe`, subscribeReqObj);
    } else {
      const unsubReqObj = {
        data: {
          entity_type: 'initiative',
          entity_uuid: uuid,
        },
      };
      await axios.delete(`/api/subscriptions/${uuid}`, unsubReqObj);
    }
    dispatch(setUser(userCopy));
  } catch (error) {
    console.error(error);
    handlePossibleExpiredToken(error);
  }
};

export const attemptUpdateAccount = (payload) => async (dispatch) => {
  const { uuid } = payload;
  const acctPayload = new AccountBody(payload);
  const errors = {
    firstName: validateAlphaNumericUnicode(acctPayload.first_name),
    lastName: validateAlphaNumericUnicode(acctPayload.last_name),
    username: validateAlphaNumericUnicode(acctPayload.username),
    city: acctPayload.city
      ? validateAlphaNumericUnicode(acctPayload.city)
      : null,
    state: acctPayload.state
      ? validateAlphaNumericUnicode(acctPayload.state)
      : null,
    zipCode: acctPayload.zip_code
      ? validateZipCode(acctPayload.zip_code)
      : null,
  };
  sanitizeData(acctPayload);

  try {
    if (formHasNoErrors(errors)) {
      const accountRes = await axios.put(`/api/accounts/${uuid}`, acctPayload);
      const settings = new SettingsReqBody(payload);
      const user = { ...settings, ...accountRes.data };
      dispatch(setUser(user));
      return;
    }
  } catch (error) {
    console.error(error);
    handlePossibleExpiredToken(error);
    const errorRes = error.response;
    if (
      errorRes &&
      errorRes.data.detail ===
        `Account with username ${acctPayload.username} already exists!`
    ) {
      errors.foundExistingUser = errorRes.data.detail;
    } else if (errorRes) {
      errors.api = errorRes.data.detail;
    }
  }
  throw errors;
};

export const getAccountAndSettingsFromOTP = (token_id, otp, cookies) => async (
  dispatch
) => {
  const errors = {};
  if (!otp) {
    errors.message = 'required One Time Pad is missing';
    throw errors;
  }

  try {
    cookies.remove('user_id', {
      path: '/',
      sameSite: 'none',
      secure: true,
    });
    dispatch(completeLogout());
    const userRes = await axios.get(
      `/api/verify_token/finish?token=${token_id}&otp=${otp}`
    );
    const account = { ...userRes.data.account };
    const refreshTime = Date.now();
    dispatch(setRefreshTime(refreshTime));
    dispatch(setUser(account));
    return;
  } catch (error) {
    console.error(error);
    errors.api = 'failed to verify account from hash';
  }
  throw errors;
};
export default userSlice.reducer;
