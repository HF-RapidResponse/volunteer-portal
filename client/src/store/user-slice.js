import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';

const userSlice = createSlice({
  name: 'userStore',

  initialState: {
    user: null,
    shownSettings: {},
  },

  reducers: {
    completeLogin: (state, action) => {
      const { payload } = action;
      payload.username = payload.username || 'andyfromtheblock'; // using this as placeholder for now
      payload.name = payload.name || 'Andie Yang'; // placeholder
      payload.city = payload.city || 'New York City'; // placeholder
      payload.state = payload.state || 'NY'; // placeholder
      payload.roles = payload.roles || [
        'President of Andy Club and the Superintendent',
        'Mr. Grinch',
      ]; // placeholder
      state.user = payload;
      console.log('Here is the user on login:', state.user);
    },
    completeLogout: (state) => {
      state.user = null;
    },
    register: (state, action) => {},
  },
});

export const { completeLogin, completeLogout } = userSlice.actions;

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

// export const verifyPassword = (payload) => async (dispatch) => {
//   //const response = await axios.get(`/users/${userSlice.user.ID}`);
//   //return response.password === (base64blah blah blah) && payload.oldPass === payload.newPass;
//   console.log('Do we ever hit verifyPassword?', payload);
//   return dispatch(
//     completeVerifyPassword(payload.newPass === payload.retypePass)
//   );
// };

export const verifyPassword = (payload) => {
  //const response = await axios.get(`/users/${userSlice.user.ID}`);
  //return response.password === (base64blah blah blah) && payload.oldPass === payload.newPass;
  console.log('Do we ever hit verifyPassword?', payload);
  const responsePayload = {
    currPassValid: true,
    newAndRetypeMatch: payload.newPass === payload.retypePass,
  };
  return responsePayload;
};

export default userSlice.reducer;
