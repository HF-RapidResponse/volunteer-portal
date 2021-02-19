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
      console.log('Here is the user on login:', state.user);
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
  dispatch(completeLogin(payload));
  return true;
};

export const oauthLogin = (payload) => async (dispatch) => {
  const { profileObj } = payload;
  console.log('profileObj on oauthLogin?', profileObj);
  try {
    console.log('window.location?', window.location);
    const host =
      window.location.origin === 'localhost:8000'
        ? 'http://localhost:8081'
        : window.location.origin;
    const existingAcct = await axios.get(
      `${host}/api/accounts/email/${profileObj.email}`
    );
    console.log('does an account exist?', existingAcct);
    const userPayload = {
      username: profileObj.googleId,
      email: profileObj.email,
      firstName: profileObj.givenName,
      lastName: profileObj.familyName,
      name: profileObj.name,
      profilePic: profileObj.imageUrl,
    };
    dispatch(completeLogin(userPayload));
  } catch (error) {
    console.error('error on oauth get:', error);
  }
};

export const startLogout = (payload) => async (dispatch) => {
  // const response = await axios.post('/api/logout-and-clear-tokens?/', payload);
  dispatch(completeLogout());
};

export const loadLoggedInUser = (payload) => (dispatch) => {
  // const response = await axios.post('/api/login', payload);
  dispatch(completeLogin(payload));
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

export const deleteUser = () => async (dispatch) => {
  //const response = await axios.delete(`/users/${userSlice.user.ID}`);
  dispatch(completeLogout());
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
