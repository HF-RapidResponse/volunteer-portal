import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';

const initiativeSlice = createSlice({
  name: 'initiativeStore',

  initialState: {
    initiatives: [],
    fetchTime: null,
    initiativeDetail: null,
  },

  reducers: {
    setInitiatives: (state, action) => {
      const { payload } = action;
      state.initiatives = payload;
    },
    setOneInitiative: (state, action) => {
      const { payload } = action;
      state.initiativeDetail = payload;
    },
  },
});

export const { setInitiatives } = initiativeSlice.actions;

export const getOneInitiative = (id) => async (dispatch) => {
  const response = await axios.get(`/api/initiatives/${id}`);
  dispatch();
};

export const getInitiatives = () => async (dispatch) => {
  const response = await axios.get('/api/initiatives');
  dispatch(setInitiatives(response.data));
};

export default initiativeSlice.reducer;
