/*
  Credit: https://stackoverflow.com/questions/2370015/regular-expression-for-password-validation
  Regex is asking for 6 to 20 character length with at least 
  1 letter, 1 number, and 1 special character
*/
export const validatePassword = (password) => {
  const regex = new RegExp(
    /(?=.*\d)(?=.*[a-zA-Z])(?=.*[`!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?~]).{6,20}/g
  );
  const isValid = password && regex.test(password);
  return isValid
    ? null
    : 'Please enter a password between 6 and 20 characters long with at least 1 letter, 1 number, and 1 special character.';
};

/*
  Credit: https://www.w3docs.com/snippets/javascript/how-to-validate-an-e-mail-using-javascript.html
*/
export const validateEmail = (email) => {
  const regex = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  const isValid = regex.test(String(email).toLowerCase());
  return isValid
    ? null
    : 'Please provide a valid e-mail address (i.e. andy@test.com)';
};

export const validateUsername = (username) => {
  if (!username) {
    return 'Please provide a username';
  }

  const isValidAlphaNumericUni = !validateAlphaNumericUnicode(username);
  const trimmedUserName = username.trim();
  return isValidAlphaNumericUni &&
    trimmedUserName.length > 4 &&
    trimmedUserName.length < 26
    ? null
    : 'Please enter a username using alphanumeric characters between 5 and and 25 characters in length';
};

/*
    Credit: https://stackoverflow.com/questions/388996/regex-for-javascript-to-allow-only-alphanumeric
*/
export const validateAlphaNumericUnicode = (word) => {
  const pattern = /^([a-zA-Z0-9\u0600-\u06FF\u0660-\u0669\u06F0-\u06F9 _.-]+)$/;
  const isValid = word && word.trim() && pattern.test(word);
  return isValid ? null : 'Please only use alphanumeric or unicode characters.';
};

export const validatePassRetype = (password, retypePass) => {
  if (!retypePass) {
    return 'Please retype your password.';
  }

  const passesMatch = password === retypePass;
  return passesMatch
    ? validatePassword(retypePass)
    : 'Password and retyped password do not match.';
};

export const validateZipCode = (zipCode) => {
  const pattern = /^\d{5}(?:[-\s]\d{4})?$/gm;
  const isValid = pattern.test(zipCode);
  return isValid ? null : 'Please enter a valid zip code.';
};

export const sanitizeData = (payload) => {
  Object.entries(payload).forEach((entry) => {
    const [key, val] = entry;
    /* eslint-disable indent */
    switch (key) {
      case 'first_name':
      case 'last_name':
      case 'city':
      case 'state':
      case 'zip_code':
      case 'username':
        payload[key] = val ? val.trim() : val;
        break;
      case 'email':
        if (val && !payload.oauth) {
          let strArr = val.trim().toLowerCase().split('@');
          const saniUser =
            strArr[1] === 'gmail.com'
              ? strArr[0].replace(/\./g, '')
              : strArr[0];
          payload[key] = `${saniUser}@${strArr[1]}`;
        }
        break;
      default:
        break;
    }
    /* eslint-enable indent */
  });
};

export const formHasNoErrors = (errors) => {
  for (const val of Object.values(errors)) {
    if (val) {
      return false;
    }
  }
  return true;
};

export const handleRegisterErrors = (response, errors) => {
  if (response) {
    if (
      response.data &&
      response.data.detail &&
      Object.keys(response.data.detail)
    ) {
      Object.entries(response.data.detail).forEach((entry) => {
        const [key, val] = entry;
        errors[key] = val;
      });
    } else {
      errors.api =
        response.data.detail ||
        'Error while attempting to create an account. Please try again later.';
    }
  }
};

export const handlePossibleExpiredToken = (error) => {
  if (
    error.response &&
    (error.response.status === 422 || error.response.status === 401)
  ) {
    window.location.reload();
  }
};
