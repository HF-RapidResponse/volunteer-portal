import { configureStore } from '@reduxjs/toolkit';
import { combineReducers } from 'redux';
import userSlice from './user-slice';

const reducer = combineReducers({
  userStore: userSlice,
});

const store = configureStore({ reducer });

export default store;
