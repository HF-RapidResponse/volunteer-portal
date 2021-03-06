import { useState } from 'react';

/**
 * custom React hook handles form change and submission of a form component
 * @param {Object} obj -  base object representing the fields the form should have
 * @param {Function} submitFunction -  function that really handles submit
 * @returns several variables and functions to be used elsewhere
 */
const useForm = (callback, initObj) => {
  const [data, setData] = useState(initObj || {});
  const [submitted, setSubmitted] = useState(false);
  const [validated, setValidated] = useState(false);
  const [errors, setErrors] = useState({});

  /**
   * event handler function of sorts that handles form change
   * takes in a key and val to add/edit to the current data object
   * @param {*} key - key/property to add/edit
   * @param {*} val - value to add/edit
   */
  const handleChange = (key, val) => {
    if (validated || submitted) {
      setValidated(false);
      setSubmitted(false);
      setErrors({});
    }
    const newData = { ...data };
    newData[key] = val;
    setData(newData);
  };

  /**
   * event handler function that handles page submission
   * designed to work with HTML page form validation
   * @param {Object} e - event object (we weant to inspect the currentTarget property)
   */
  const handleSubmit = async (e) => {
    setErrors({});
    e.preventDefault();
    e.stopPropagation();

    try {
      await callback(data);
      setValidated(true);
      setSubmitted(true);
      return true;
    } catch (errors) {
      setErrors(errors);
      setSubmitted(false);
      return false;
    }
  };

  const resetForm = () => {
    setData(initObj || {});
    setValidated(false);
    setSubmitted(false);
    setErrors({});
  };

  return {
    handleChange,
    handleSubmit,
    data,
    setData,
    submitted,
    setSubmitted,
    validated,
    setValidated,
    errors,
    setErrors,
    resetForm,
  };
};

export default useForm;
