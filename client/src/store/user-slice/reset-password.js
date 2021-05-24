import axios from 'axios';
import { AccountBody, SettingsReqBody } from './classes';
import {
  validatePassword,
  validateEmail,
  validatePassRetype,
  validateUsername,
  sanitizeData,
  formHasNoErrors,
} from './helpers';

export const attemptSendResetEmail = async (payload) => {
  const { username_or_email } = payload;
  const errors = {};
  const hasUsernameErr = validateUsername(username_or_email);
  const hasEmailErr = validateEmail(username_or_email);
  if (hasEmailErr && hasUsernameErr) {
    errors.usernameOrEmail = 'Invalid username or e-mail';
    throw errors;
  } else {
    const obj = {
      notification_type: 'password_reset',
    };
    if (!hasEmailErr) {
      obj.email = username_or_email;
    } else if (!hasUsernameErr) {
      obj.username = username_or_email;
    }
    await axios.post(`/api/notifications/`, obj);
  }
};

export const getSettingsFromHash = async (hash) => {
  const errors = {};
  try {
    const getSettingsRes = await axios.get(
      `/api/settings_from_hash?pw_reset_hash=${hash}`
    );
    return getSettingsRes.data;
  } catch (error) {
    console.error(error);
    errors.api = 'an error occurred while trying to get settings from hash';
  }
  throw errors;
};

export const attemptResetPassword = async (payload) => {
  const { password, retypePass, uuid } = payload;
  const errors = {
    password: validatePassword(password),
    retypePass: validatePassRetype(password, retypePass),
  };
  try {
    if (formHasNoErrors(errors)) {
      sanitizeData(password);
      await axios.patch(
        `/api/accounts/${uuid}`, { password: password }
      );
      await resetPasswordAndInfo(uuid);
      return;
    }
  } catch (error) {
    console.error(error);
    errors.api = 'an error occurred while trying to reset password';
  }
  throw errors;
};

const resetPasswordAndInfo = async (id) => {
  try {
    const settingsRes = await axios.get(`/api/account_settings/${id}`);
    const settings = settingsRes ? settingsRes.data : null;
    if (settings) {
      const updatedSettings = new SettingsReqBody({
        ...settings,
        password_reset_hash: null,
        password_reset_time: null,
      });
      await axios.put(`/api/account_settings/${id}`, updatedSettings);
      await axios.delete(`/api/logout`);
    }
  } catch (error) {
    console.error(error);
  }
};
