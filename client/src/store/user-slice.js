import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';

const userSlice = createSlice({
  name: 'userStore',

  initialState: {
    user: null,
    shownSettings: {},
    firstAcctPage: null,
    tokenRefreshTime: null,
  },

  reducers: {
    setUser: (state, action) => {
      const { payload } = action;
      state.user = payload;
      console.log('Here is the user on login:', state.user);
    },
    setRefreshTime: (state, action) => {
      const { payload } = action;
      state.tokenRefreshTime = payload;
    },
    completeLogout: (state) => {
      state.user = null;
      state.shownSettings = {};
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

class AccountReqBody {
  constructor(obj) {
    this.username = obj.username;
    this.email = obj.email;
    this.first_name = obj.first_name;
    this.last_name = obj.last_name;
    this.password = obj.password;
    this.oauth = obj.oauth;
    this.profile_pic = obj.profile_pic;
    this.roles = obj.roles || [];
    this.initiative_map = obj.initiative_map || {};
    this.organizers_can_see = true;
    this.volunteers_can_see = true;
  }
}

class SettingsReqBody {
  constructor(obj) {
    this.uuid = obj.uuid;
    this.show_name = obj.show_name ?? true;
    this.show_email = obj.show_email ?? true;
    this.show_location = obj.show_location ?? true;
    this.organizers_can_see = obj.organizers_can_see ?? true;
    this.volunteers_can_see = obj.volunteers_can_see ?? true;
    this.initiative_map = obj.initiative_map || {};
  }
}

export const attemptLogin = (payload) => async (dispatch) => {
  const errors = {};
  try {
    const accountRes = await axios.post(`/api/auth/basic`, payload);
    const accountData = accountRes.data;
    const refreshTime = Date.now();
    dispatch(setRefreshTime(refreshTime));
    const settings = await getSettings(accountData.uuid);
    const user = { ...accountData, ...settings };
    dispatch(setUser(user));
    return true;
  } catch (error) {
    console.error(error);
    errors.message = 'Email or password is invalid!';
  }
  throw errors;
};

const getSettings = async (id) => {
  if (!id) {
    throw 'missing required id param';
  }

  try {
    const getRes = await axios.get(`/api/settings/${id}`);
    let settings;
    if (getRes.data) {
      settings = getRes.data;
    } else {
      const initiative_map = await updateInitiativeMap();
      const createRes = await axios.post(
        `/api/settings/`,
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
    console.log('token refreshed at:', refreshTime);
    return refreshTime;
  } catch (error) {
    console.error(error);
  }
};

export const refreshTokenIfNeeded = (tokenRefreshTime) => async (dispatch) => {
  const currTime = Date.now();
  const timeDiff = currTime - tokenRefreshTime;

  if (!tokenRefreshTime || timeDiff > 750000) {
    console.log('token needs a refresh', timeDiff);
    const newRefreshTime = await refreshAccessToken();
    dispatch(setRefreshTime(newRefreshTime));
  }
};

export const startLogout = () => async (dispatch) => {
  try {
    await refreshAccessToken();
    await axios.delete(`/api/logout`);
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
  console.log('beginning of attempt create', payload);
  const errors = {};
  const emailIsValid = validateEmail(payload.email);
  console.log('Is email valid?', emailIsValid);
  if (!emailIsValid) {
    errors.email = 'Please enter a valid e-mail.';
  }
  const passwordIsValid = validatePassword(payload.password);
  if (!passwordIsValid) {
    errors.password =
      'Please enter a password between 6 and 20 characters long with at least 1 letter, 1 nuumber, and 1 special character.';
  }

  const passAndRetypeMatch = payload.password === payload.retypePass;
  if (!passAndRetypeMatch) {
    errors.retypePass = 'Passwords do not match!';
  }

  if (emailIsValid && passwordIsValid && passAndRetypeMatch) {
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
      console.error('API error when attempting to create user:', error);
      errors.api =
        error.response.data.detail ||
        'Error while attempting to create an account. Please try again later.';
      throw errors;
    }
  }
  throw errors;
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
  const newPassValidated = validatePassword(newPass);
  const newPassesMatch = newPass === retypePass;
  const errors = {
    oldPassInvalid: true,
    newPassRetypeMismatch: !newPassesMatch,
    newPassInvalid: !newPassValidated,
  };

  try {
    const acctReqObj = {
      old_password: oldPass,
      uuid: uuid,
    };
    dispatch(refreshTokenIfNeeded(tokenRefreshTime));
    const oldPassIsValid = await axios.post(`/api/verify_password`, acctReqObj);

    if (oldPassIsValid.data && newPassValidated && newPassesMatch) {
      errors.oldPassInvalid = false;

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
    handlePossibleExpiredToken(error);
  }
  throw errors;
};

export const deleteRole = (payload) => async (dispatch) => {
  //const response = await axios.delete(`/users/${userSlice.user.ID}/roles/${payload.roleID}`);
  dispatch(completeDelete(payload));
};

export const deleteUser = (uuid) => async (dispatch) => {
  try {
    await refreshAccessToken();
    await axios.delete(`/api/settings/${uuid}`);
    await axios.delete(`/api/accounts/${uuid}`);
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
export const validatePassword = (payload) => {
  console.log('inside validatePassword?', payload);
  if (!payload) {
    return false;
  }
  return payload.match(/(?=.*\d)(?=.*[a-zA-Z])(?=.*[!#$%&?]).{6,20}/g);
};

export const basicPropUpdate = (payload) => async (dispatch) => {
  const { user, key, newVal, tokenRefreshTime } = payload;
  let userCopy = { ...user };
  userCopy[key] = newVal;
  try {
    // const refreshRes = await axios.post(`/api/refresh`);
    console.log('any tokenRefreshTime in toggle basic prop?', tokenRefreshTime);
    dispatch(refreshTokenIfNeeded(tokenRefreshTime));
    // console.log('refreshRes?', refreshRes.data);
    const settingsReq = new SettingsReqBody(userCopy);
    const response = await axios.put(
      `/api/settings/${settingsReq.uuid}`,
      settingsReq
    );
    userCopy = { ...userCopy, ...response.data };
    console.log('userCopy after put?', userCopy);
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
    // const refreshRes = await axios.post(`/api/refresh`);
    // console.log('refreshRes?', refreshRes.data);
    console.log('any tokenRefreshTime in toggle initiative?', tokenRefreshTime);
    dispatch(refreshTokenIfNeeded(tokenRefreshTime));
    const settingsReq = new SettingsReqBody(userCopy);
    const response = await axios.put(
      `/api/settings/${settingsReq.uuid}`,
      settingsReq
    );
    userCopy = { ...userCopy, ...response.data };
    dispatch(completeUserUpdate(userCopy));
  } catch (error) {
    console.error(error);
    handlePossibleExpiredToken(error);
  }
};

/*
  Credit: https://www.w3docs.com/snippets/javascript/how-to-validate-an-e-mail-using-javascript.html
*/
export const validateEmail = (email) => {
  const res = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  console.log(
    'did we get into validateEmail?',
    res.test(String(email).toLowerCase())
  );
  return res.test(String(email).toLowerCase());
};

export default userSlice.reducer;
