import { configureStore } from '@reduxjs/toolkit';
import { combineReducers } from 'redux';
import userSlice from './user-slice';
import initiativeSlice from './initiative-slice';

const reducer = combineReducers({
  userStore: userSlice,
  initiativeStore: initiativeSlice,
});

const store = configureStore({ reducer });

export default store;
