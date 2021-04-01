import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';
import { AccountReqBody, SettingsReqBody } from './classes';
import {
  validatePassword,
  validateEmail,
  validateAlphaNumericUnicode,
  validatePassRetype,
  validateZipCode,
  validateUsername,
  sanitizeData,
  formHasNoErrors,
} from './helpers';

const userSlice = createSlice({
  name: 'userStore',

  initialState: {
    user: null,
    firstAcctPage: null,
    tokenRefreshTime: null,
    initLoading: false,
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
      const refreshTime = Date.now();
      dispatch(setRefreshTime(refreshTime));
      const settings = await getSettings(accountData.uuid);
      const user = { ...accountData, ...settings };
      dispatch(setUser(user));
      return;
    }
  } catch (error) {
    console.error(error);
  }
  errors.message = 'Email or password is invalid!';
  throw errors;
};

const getSettings = async (id) => {
  if (!id) {
    throw 'missing required id param';
  }

  try {
    const getRes = await axios.get(`/api/account_settings/${id}`);
    let settings;
    if (getRes.data) {
      settings = getRes.data;
    } else {
      const initiative_map = await updateInitiativeMap();
      const createRes = await axios.post(
        `/api/account_settings/`,
        new SettingsReqBody({ uuid: id, initiative_map })
      );
      settings = createRes.data;
    }
    return settings;
  } catch (error) {
    console.error(error);
  }
};

const updateInitiativeMap = async (initiative_map = {}) => {
  const initiativeResponse = await axios.get(`/api/initiatives/`);
  const updatedMap = {};
  const initiatives = initiativeResponse.data;

  if (initiatives && initiatives.length) {
    initiatives.forEach((item) => {
      updatedMap[item.initiative_name] =
        initiative_map[item.initiative_name] || false;
    });
  }
  return updatedMap;
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
    dispatch(setRefreshTime(null));
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
    const objPayload = new AccountReqBody(payload);
    const accountRes = await axios.post(`/api/accounts/`, objPayload);
    const accountData = accountRes.data;
    const settings = await getSettings(accountData.uuid);
    const user = { ...accountData, ...settings };
    dispatch(setUser(user));
    const refreshTime = await refreshAccessToken();
    dispatch(setRefreshTime(refreshTime));
    return;
  } catch (error) {
    handleApiErrors(error.response, errors);
  }
  throw errors;
};

const handleApiErrors = (response, errors) => {
  if (response) {
    if (
      response.data &&
      response.data.detail &&
      Object.keys(response.data.detail)
    ) {
      Object.entries(response.data.detail).forEach((entry) => {
        const [key, val] = entry;
        errors[key] = val;
      });
    } else {
      errors.api =
        response.data.detail ||
        'Error while attempting to create an account. Please try again later.';
    }
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
      const accountRes = await axios.patch(
        `/api/accounts/${uuid}`,
        new AccountReqBody({
          password: newPass,
        })
      );

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
  //const response = await axios.delete(`/users/${userSlice.user.ID}/roles/${payload.roleID}`);
  dispatch(completeDelete(payload));
};

export const deleteUser = (uuid, cookies) => async (dispatch) => {
  try {
    await refreshAccessToken();
    await axios.delete(`/api/account_settings/${uuid}`);
    await axios.delete(`/api/accounts/${uuid}`);
    cookies.remove('user_id', { path: '/', sameSite: 'None', secure: true });
    dispatch(completeLogout());
  } catch (error) {
    console.error(error);
    handlePossibleExpiredToken(error);
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

const handlePossibleExpiredToken = (error) => {
  if (error.response && error.response.status === 422) {
    window.location.reload();
  }
};

export const toggleInitiativeSubscription = (payload) => async (dispatch) => {
  const { user, initiative_name, isSubscribed, tokenRefreshTime } = payload;
  let userCopy = { ...user };
  userCopy.initiative_map = {
    ...userCopy.initiative_map,
  };
  userCopy.initiative_map[initiative_name] = !isSubscribed;

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

export const attemptUpdateAccount = (payload) => async (dispatch) => {
  const { uuid } = payload;
  const acctPayload = new AccountReqBody(payload);
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
    email: validateEmail(acctPayload.email),
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

export const attemptSendResetEmail = async (payload) => {
  const { username_or_email } = payload;
  const errors = {};
  const hasUsernameErr = validateUsername(username_or_email);
  const hasEmailErr = validateEmail(username_or_email);
  if (hasEmailErr && hasUsernameErr) {
    errors.usernameOrEmail = true;
    throw errors;
  } else {
    const obj = {};
    if (!hasEmailErr) {
      obj.email = username_or_email;
    } else if (!hasUsernameErr) {
      obj.username = username_or_email;
    }
    await axios.post(`/api/notifications/`, obj);
  }
};

export const getSettingsFromHash = async (hash) => {
  const errors = {};
  try {
    const getSettingsRes = await axios.get(
      `/api/settings_from_hash?pw_reset_hash=${hash}`
    );
    return getSettingsRes.data;
  } catch (error) {
    console.error(error);
    handleApiErrors(error.response, errors);
  }
  throw errors;
};

export const attemptResetPassword = async (payload) => {
  const { password, retypePass, uuid } = payload;
  const errors = {
    password: validatePassword(password),
    retypePass:
      validatePassword(retypePass) || validatePassRetype(password, retypePass),
  };
  sanitizeData(password);
  try {
    if (formHasNoErrors(errors)) {
      await axios.patch(
        `/api/accounts/${uuid}`,
        new AccountReqBody({
          password,
        })
      );
      await resetPasswordResetInfo(uuid);
      return;
    }
  } catch (error) {
    console.error(error);
    handleApiErrors(error.response, errors);
  }
  throw errors;
};

const resetPasswordResetInfo = async (id) => {
  try {
    const settingsRes = await axios.get(`/api/account_settings/${id}`);
    const settings = settingsRes ? settingsRes.data : null;
    if (settings) {
      const updatedSettings = new SettingsReqBody({
        ...settings,
        password_reset_hash: null,
        password_reset_time: null,
      });
      await axios.put(`/api/account_settings/${id}`, updatedSettings);
    }
  } catch (error) {
    console.error(error);
  }
};

export default userSlice.reducer;
