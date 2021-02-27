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
    setUser: (state, action) => {
      const { payload } = action;
      state.user = payload;
      console.log('Here is the user on login:', state.user);
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
      // const { user, initiativeName, isSubscribed } = payload;
      console.log('What is in payload?', payload);
      state.user = payload;
      //state.user[initiativeName] = !isSubscribed;
      console.log('Did user update?', state.user);
    },
  },
});

export const {
  setUser,
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
    this.profile_pic = obj.profile_pic;
    this.roles = obj.roles || [];
    this.initiative_map = obj.initiative_map || {};
    this.organizers_can_see = true;
    this.volunteers_can_see = true;
  }
}

export const attemptLogin = (payload) => async (dispatch) => {
  dispatch(setUser(payload));
  return true;
};

export const openGoogleOauthWindow = async () => {
  try {
    const baseUrl =
      window.location.port === '8000'
        ? 'http://localhost:8081'
        : window.location.origin;
    const oauthUrl = `${baseUrl}/api/login?provider=google`;
    console.log('What is oauthUrl?', oauthUrl);
    const response = await axios.get(oauthUrl);
    console.log('any data from response?', response.data);
  } catch (error) {
    console.error(error);
  }
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

export const syncInitMapAndLoadUser = (id) => async (dispatch) => {
  try {
    const userRes = await axios.get(`/api/accounts/${id}`);
    const { initiative_map } = userRes.data;
    const initiativeResponse = await axios.get(`/api/initiatives/`);
    const updatedMap = {};
    const initiatives = initiativeResponse.data;

    if (initiatives && initiatives.length) {
      initiatives.forEach((item) => {
        updatedMap[item.initiative_name] =
          initiative_map[item.initiative_name] || false;
      });
    }

    const userCopy = { ...userRes.data, initiative_map: updatedMap };
    console.log('did we hit userCopy?', userCopy);
    const updatedAcctRes = await axios.put(`/api/accounts/${id}`, userCopy);
    dispatch(setUser(updatedAcctRes.data));
  } catch (error) {
    console.error(error);
  }
};

export const startLogout = (id) => async (dispatch) => {
  // const response = await axios.post('/api/logout-and-clear-tokens?/', payload);
  // await axios.delete(`/api/logout`);
  dispatch(completeLogout());
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
    dispatch(loadLoggedInUser(payload));
    return true;
  }
  console.log('errors here?', errors);
  throw errors;
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

export const deleteUser = (uuid) => async (dispatch) => {
  try {
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
  const { user, key, newVal } = payload;
  const userCopy = { ...user };
  userCopy[key] = newVal;
  try {
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
  const { user, initiative_name, isSubscribed } = payload;
  const userCopy = { ...user };
  userCopy.initiative_map = {
    ...userCopy.initiative_map,
  };
  userCopy.initiative_map[initiative_name] = !isSubscribed;

  try {
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
