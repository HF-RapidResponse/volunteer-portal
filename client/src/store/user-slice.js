import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';

const userSlice = createSlice({
  name: 'userStore',

  initialState: {
    user: null,
    shownSettings: {},
    firstAcctPage: null,
  },

  reducers: {
    completeLogin: (state, action) => {
      const { payload } = action;
      payload.id = payload.id || '1234';
      payload.username = payload.username || 'andyfromtheblock'; // using this as placeholder for now
      payload.name = payload.name || 'Andie Yang'; // placeholder
      payload.city = payload.city || 'New York City'; // placeholder
      payload.state = payload.state || 'NY'; // placeholder
      payload.roles = payload.roles || [
        'President of Andy Club and the Superintendent',
        'Mr. Grinch',
      ]; // placeholder
      payload.initiativeMap = payload.initiativeMap || {
        'Fundraising for UBI campaign': true,
        'Congressional Pressure for UBI': true,
        'Normalize Human Centered Policies': true,
      };
      state.user = payload;
      // console.log('Here is the user on login:', state.user);
    },
    completeLogout: (state) => {
      state.user = null;
      state.shownSettings = {};
      state.firstAcctPage = null;
    },
    register: (state, action) => {},
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
      // const { user, initiativeName, isSubscribed } = payload;
      console.log('What is in payload?', payload);
      state.user = payload;
      //state.user[initiativeName] = !isSubscribed;
      console.log('Did user update?', state.user);
    },
  },
});

export const {
  completeLogin,
  completeLogout,
  setFirstAcctPage,
  completeDelete,
  completeUserUpdate,
} = userSlice.actions;

export const attemptLogin = (payload) => async (dispatch) => {
  // const response = await axios.post('/api/login-or-something-like-that/', payload);
  // if (response.ok) {
  //   dispatch(login(response.data));
  //   return true;
  // } else {
  //   return false;
  // }
  dispatch(completeLogin(payload));
  return true;
};

export const startLogout = (payload) => async (dispatch) => {
  // const response = await axios.post('/api/logout-and-clear-tokens?/', payload);
  dispatch(completeLogout());
};

export const loadLoggedInUser = (payload) => (dispatch) => {
  // const response = await axios.post('/api/login', payload);
  dispatch(completeLogin(payload));
};

export const verifyPassword = (payload) => {
  //const response = await axios.get(`/users/${userSlice.user.ID}`);
  //return response.password === (base64blah blah blah) && payload.oldPass === payload.newPass;
  // console.log('Do we ever hit verifyPassword?', payload);
  const responsePayload = {
    currPassValid: true,
    newAndRetypeMatch: payload.newPass === payload.retypePass,
  };
  return responsePayload;
};

export const deleteRole = (payload) => async (dispatch) => {
  //const response = await axios.delete(`/users/${userSlice.user.ID}/roles/${payload.roleID}`);
  dispatch(completeDelete(payload));
};

export const deleteUser = () => async (dispatch) => {
  //const response = await axios.delete(`/users/${userSlice.user.ID}/delete`);
  dispatch(completeLogout());
};

export const validatePassword = (payload) => async (dispatch) => {
  const lengthReq = payload.length >= 5;
  const hasSpecialChars = payload.match(/^[a-zA-Z0-9!@#$%^&*)(+=._-]+$/g);
};

export const toggleInitiativeSubscription = (payload) => async (dispatch) => {
  const { user, initiativeName, isSubscribed } = payload;
  const userCopy = { ...user };
  userCopy.initiativeMap = {
    ...userCopy.initiativeMap,
  };
  userCopy.initiativeMap[initiativeName] = !isSubscribed;
  //const response = await axios.put(`/users/user.id`, user);
  dispatch(completeUserUpdate(userCopy));
};

export default userSlice.reducer;
