import axios from 'axios';
import { createSlice } from '@reduxjs/toolkit';

// console.log('What is window.location?', window.location);
// const axiosInstance = axios.create({
//   baseURL:
//     window.location.host === 'localhost:8000'
//       ? 'http://localhost:8081'
//       : window.location.host,
// });

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
  console.log('What is window.location?', window.location);
  const response = await axios.get(`/api/initiatives/${id}`);
  dispatch();
};

export const getInitiatives = () => async (dispatch) => {
  try {
    const response = await axios.get('/api/initiatives');
    dispatch(setInitiatives(response.data));
  } catch (error) {
    console.error(error);
  }
};

export default initiativeSlice.reducer;
