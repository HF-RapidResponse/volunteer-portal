import axios from 'axios';

export const cancelRegistrationFromhash = async (hash) => {
  const errors = {};
  if (!hash) {
    errors.message = 'required hash is missing';
    throw errors;
  }

  try {
    await axios.delete(
      `/api/cancel_registration_from_hash?cancel_hash=${hash}`
    );
  } catch (error) {
    console.error(error);
    errors.api = 'failed to cancel registration';
    throw errors;
  }
};
