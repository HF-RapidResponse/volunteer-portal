import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';
import { get } from 'lodash';

const userSlice = createSlice({
  name: 'userStore',

  initialState: {
    user: null,
    firstAcctPage: null,
    tokenRefreshTime: null,
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
    completeUserUpdate: (state, action) => {
      const { payload } = action;
      state.user = payload;
    },
  },
});

export const {
  setUser,
  setRefreshTime,
  completeLogout,
  setFirstAcctPage,
  completeDelete,
  completeUserUpdate,
} = userSlice.actions;

export class AccountReqBody {
  constructor(obj) {
    this.username = obj.username;
    this.email = obj.email;
    this.first_name = obj.first_name;
    this.last_name = obj.last_name;
    this.password = obj.password;
    this.oauth = obj.oauth;
    this.profile_pic = obj.profile_pic;
    this.city = obj.city;
    this.state = obj.state;
    this.roles = obj.roles || [];
  }
}

export class SettingsReqBody {
  constructor(obj) {
    this.uuid = obj.uuid;
    this.show_name = obj.show_name ?? false;
    this.show_email = obj.show_email ?? false;
    this.show_location = obj.show_location ?? false;
    this.organizers_can_see = obj.organizers_can_see ?? true;
    this.volunteers_can_see = obj.volunteers_can_see ?? true;
    this.initiative_map = obj.initiative_map || {};
  }
}

export const attemptLogin = (payload) => async (dispatch) => {
  const { email, password } = payload;
  const errors = {
    email: validateEmail(email),
    password: validatePassword(password),
  };
  try {
    if (formHasNoErrors(errors)) {
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

export const refreshTokenIfNeeded = (tokenRefreshTime) => async (dispatch) => {
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
      sameSite: 'None',
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

export const attemptCreateAccount = (payload) => async (dispatch) => {
  if (!payload) {
    return false;
  }

  const errors = {
    firstName: validateAlphaNumericUnicode(payload.first_name),
    lastName: validateAlphaNumericUnicode(payload.last_name),
    username: validateAlphaNumericUnicode(payload.username),
    email: validateEmail(payload.email),
    password: validatePassword(payload.password),
    retypePass: validatePassRetype(payload.password, payload.retypePass),
  };

  if (formHasNoErrors(errors)) {
    try {
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
  }
  throw errors;
};

const handleApiErrors = (response, errors) => {
  if (response) {
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
  }
};

export const verifyPassword = (payload) => {
  const responsePayload = {
    currPassValid: true,
    newAndRetypeMatch: payload.newPass === payload.retypePass,
  };
  return responsePayload;
};

export const changePassword = (payload) => async (dispatch) => {
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
    console.error(error);
    errors.oldPassInvalid = true;
    handlePossibleExpiredToken(error);
  }
  console.log('errors to throw:', errors);
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

/*
  Credit: https://stackoverflow.com/questions/2370015/regular-expression-for-password-validation
  Regex is asking for 6 to 20 character length with at least 
  1 letter, 1 number, and 1 special characters
*/
export const validatePassword = (password) => {
  const regex = new RegExp(
    /(?=.*\d)(?=.*[a-zA-Z])(?=.*[`!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?~]).{6,20}/g
  );
  const isValid = password && regex.test(password);
  return isValid
    ? null
    : 'Please enter a password between 6 and 20 characters long with at least 1 letter, 1 number, and 1 special character.';
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
    dispatch(completeUserUpdate(userCopy));
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
    dispatch(completeUserUpdate(userCopy));
  } catch (error) {
    console.error(error);
    handlePossibleExpiredToken(error);
  }
};

export const attemptAccountUpdate = (payload) => async (dispatch) => {
  const { uuid } = payload;
  const acctPayload = new AccountReqBody(payload);
  const errors = {
    firstName: validateAlphaNumericUnicode(acctPayload.first_name),
    lastName: validateAlphaNumericUnicode(acctPayload.last_name),
    username: validateAlphaNumericUnicode(acctPayload.username),
    email: validateEmail(acctPayload.email),
  };

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

export const formHasNoErrors = (errors) => {
  for (const val of Object.values(errors)) {
    if (val) {
      return false;
    }
  }
  return true;
};

/*
  Credit: https://www.w3docs.com/snippets/javascript/how-to-validate-an-e-mail-using-javascript.html
*/
export const validateEmail = (email) => {
  const regex = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  const isValid = regex.test(String(email).toLowerCase());
  return isValid
    ? null
    : 'Please provide a valid e-mail address (i.e. andy@test.com)';
};

/*
  Credit: https://stackoverflow.com/questions/388996/regex-for-javascript-to-allow-only-alphanumeric
*/
export const validateAlphaNumericUnicode = (word) => {
  const pattern = /^([a-zA-Z0-9\u0600-\u06FF\u0660-\u0669\u06F0-\u06F9 _.-]+)$/;
  const isValid = word && pattern.test(word);
  return isValid ? null : 'Please only use alphanumeric or unicode characters.';
};

const validatePassRetype = (password, retypePass) => {
  const passesMatch = password === retypePass;
  return passesMatch ? null : 'Password and retyped passwords do not match.';
};

export default userSlice.reducer;
