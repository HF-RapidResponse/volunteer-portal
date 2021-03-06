import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';

const initiativeSlice = createSlice({
  name: 'initiativeStore',

  initialState: {
    initiatives: [],
    fetchTime: null,
    detailedInitiative: null,
  },

  reducers: {
    setInitiatives: (state, action) => {
      const { payload } = action;
      state.initiatives = payload;
    },
    setOneInitiative: (state, action) => {
      const { payload } = action;
      state.detailedInitiative = payload;
    },
  },
});

export const { setInitiatives, setOneInitiative } = initiativeSlice.actions;

export const getOneInitiative = (id) => async (dispatch) => {
  try {
    const response = await axios.get(`/api/initiatives/${id}`);
    dispatch(setOneInitiative(response.data));
  } catch (error) {
    console.error(error);
  }
};

export const getInitiatives = () => async (dispatch) => {
  try {
    const response = await axios.get(`/api/initiatives/`);
    dispatch(setInitiatives(response.data));
  } catch (error) {
    console.error(error);
  }
};

export default initiativeSlice.reducer;
