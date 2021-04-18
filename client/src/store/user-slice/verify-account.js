import axios from 'axios';

export const getAccountAndSettingsFromHash = async (hash) => {
  const errors = {};
  if (!hash) {
    errors.message = 'required hash is missing';
    throw errors;
  }

  try {
    await axios.get(`/api/verify_account_from_hash?verify_hash=${hash}`);
    return;
  } catch (error) {
    console.error(error);
    errors.detail = error;
  }
  throw errors;
};
