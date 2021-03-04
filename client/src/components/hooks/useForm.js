import { useState } from 'react';

/**
 * custom React hook handles form change and submission of a form component
 * @param {Object} obj -  base object representing the fields the form should have
 * @param {Function} submitFunction -  function that really handles submit
 * @returns several variables and functions to be used elsewhere
 */
function useForm(callback, initObj) {
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
  function handleChange(key, val) {
    const newData = { ...data };
    newData[key] = val;
    console.log('What is newData now?', newData);
    setData(newData);
  }

  /**
   * event handler function that handles page submission
   * designed to work with HTML page form validation
   * @param {Object} e - event object (we weant to inspect the currentTarget property)
   */
  function handleSubmit(e) {
    const form = e.currentTarget;
    setErrors({});
    e.preventDefault();
    e.stopPropagation();
    if (form.checkValidity() === false) {
      console.log('in the false?');
      return false;
    } else {
      callback(data)
        .then(() => {
          setSubmitted(true);
          // return response;
        })
        .catch((error) => {
          console.error('Did we get an error?', error);
          setErrors(error);
          setSubmitted(false);
          // return false;
        });
    }
  }

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
  };
}

export default useForm;
