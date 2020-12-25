import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';

const userSlice = createSlice({
  name: 'userStore',

  initialState: {
    user: null,
  },

  reducers: {
    completeLogin: (state, action) => {
      const { payload } = action;
      payload.username = payload.username || 'andyfromtheblock'; // using this as placeholder for now
      state.user = payload;
      console.log('Here is the user on login:', state.user);
    },
    logout: (state, action) => {
      state.user = null;
    },
    register: (state, action) => {},
  },
});

export const { completeLogin, logout } = userSlice.actions;

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

export default userSlice.reducer;
