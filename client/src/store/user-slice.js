import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';
const jwt = require('jsonwebtoken');

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
      console.log('What is tokenRefreshTime now?', state.tokenRefreshTime);
    },
    completeLogout: (state) => {
      state.user = null;
      state.shownSettings = {};
      state.firstAcctPage = null;
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
      console.log('Did user update?', state.user);
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

export const attemptLogin = (payload) => async (dispatch) => {
  const errors = {};
  try {
    const response = await axios.post(`/api/auth/basic`, payload);
    const refreshTime = Date.now();
    dispatch(setRefreshTime(refreshTime));
    const user = response.data;
    console.log('What is user after login attempt?', user);
    user.initiative_map = await updateInitiativeMap(user.initiative_map);
    dispatch(setUser(user));
    return true;
  } catch (error) {
    console.error(error);
    errors.message = 'Email or password is invalid!';
  }
  throw errors;
};

export const getUserFromID = (id) => async (dispatch) => {
  try {
    const response = await axios.get(`/api/accounts/${id}`);
    if (!response.data) {
      throw `User with ID ${id} does not exist.`;
    }
    dispatch(setUser(response.data));
  } catch (error) {
    console.error('Failed to get user by ID:', error);
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
    const userRes = await axios.get(`/api/accounts/${id}`);
    const { initiative_map } = userRes.data;
    const userCopy = {
      ...userRes.data,
      initiative_map: await updateInitiativeMap(initiative_map),
    };
    console.log('did we hit userCopy?', userCopy);
    const updatedAcctRes = await axios.put(`/api/accounts/${id}`, userCopy);
    // const user = { ...updatedAcctRes.data, refreshTime };
    dispatch(setUser(updatedAcctRes.data));
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

  console.log('What are values here?', currTime, tokenRefreshTime);
  if (tokenRefreshTime && timeDiff > 750000) {
    console.log('token needs a refresh', timeDiff);
    const newRefreshTime = await refreshAccessToken();
    dispatch(setRefreshTime(newRefreshTime));
  }
};

export const startLogout = () => async (dispatch) => {
  try {
    await refreshAccessToken();
    await axios.delete(`/api/logout`);
    // console.log('refreshRes?', refreshRes.data);
    dispatch(setRefreshTime(null));
    dispatch(completeLogout());
  } catch (error) {
    console.error(error);
  }
};

export const loadLoggedInUser = (payload) => (dispatch) => {
  // const response = await axios.post('/api/login', payload);
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
      objPayload.initiative_map = await updateInitiativeMap();
      const response = await axios.post(`/api/accounts/`, objPayload);
      dispatch(setUser(response.data));
      const refreshTime = await refreshAccessToken();
      dispatch(setRefreshTime(refreshTime));
      return true;
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
  const newPassValidated = validatePassword(payload.newPass);
  const newPassesMatch = payload.newPass === payload.retypePass;
  const errors = {
    oldPassInvalid: true,
    newPassRetypeMismatch: !newPassesMatch,
    newPassInvalid: !newPassValidated,
  };

  try {
    // await refreshAccessToken();
    const acctReqObj = {
      old_password: payload.oldPass,
      uuid: payload.uuid,
    };
    console.log('payload going into verify pw?', acctReqObj);
    const oldPassIsValid = await axios.post(`/api/verify_password`, acctReqObj);

    const response = await axios.put(
      `/api/accounts/${payload.uuid}`,
      new AccountReqBody({
        ...payload,
        password: payload.newPass,
      })
    );
    errors.oldPassInvalid = false;
    if (oldPassIsValid.data && newPassValidated && newPassesMatch) {
      dispatch(setUser(response.data));
      return true;
    }
  } catch (error) {
    console.error(error.response);
  }
  throw errors;
};

export const deleteRole = (payload) => async (dispatch) => {
  //const response = await axios.delete(`/users/${userSlice.user.ID}/roles/${payload.roleID}`);
  dispatch(completeDelete(payload));
};

export const deleteUser = (uuid) => async (dispatch) => {
  try {
    const refreshRes = await axios.post(`/api/refresh`);
    // console.log('refreshRes?', refreshRes.data);
    await axios.delete(`/api/accounts/${uuid}`);
    dispatch(completeLogout());
  } catch (error) {
    console.error(error);
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
  const userCopy = { ...user };
  userCopy[key] = newVal;
  try {
    // const refreshRes = await axios.post(`/api/refresh`);
    console.log('any tokenRefreshTime in toggle basic prop?', tokenRefreshTime);
    dispatch(refreshTokenIfNeeded(tokenRefreshTime));
    // console.log('refreshRes?', refreshRes.data);
    const response = await axios.put(
      `/api/accounts/${userCopy.uuid}`,
      userCopy
    );
    dispatch(completeUserUpdate(response.data));
  } catch (error) {
    console.error(error);
  }
};

export const toggleInitiativeSubscription = (payload) => async (dispatch) => {
  const { user, initiative_name, isSubscribed, tokenRefreshTime } = payload;
  const userCopy = { ...user };
  userCopy.initiative_map = {
    ...userCopy.initiative_map,
  };
  userCopy.initiative_map[initiative_name] = !isSubscribed;

  try {
    // const refreshRes = await axios.post(`/api/refresh`);
    // console.log('refreshRes?', refreshRes.data);
    console.log('any tokenRefreshTime in toggle initiative?', tokenRefreshTime);
    dispatch(refreshTokenIfNeeded(tokenRefreshTime));
    const response = await axios.put(
      `/api/accounts/${userCopy.uuid}`,
      userCopy
    );
    console.log('What is response.data?', response.data);
    dispatch(completeUserUpdate(response.data));
  } catch (error) {
    console.error(error);
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
