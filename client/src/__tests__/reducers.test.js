import userReducer, {
  completeLogin,
  completeLogout,
} from '../store/user-slice.js';

describe('user reducer', () => {
  const testUser = {
    ID: '12345',
    email: 'andy@test.com',
    username: 'andyfromtheblock',
    name: 'Andy Yang',
    city: 'New York City',
    state: 'NY',
    roles: ['President of Andy Club and the Superintendent', 'Mr. Grinch'],
    picture: 'https://via.placeholder.com/300/09f/fff.png',
  };

  it('can login and logout', () => {
    let newState = userReducer({}, completeLogin(testUser));

    expect(newState.user).toMatchObject(testUser);
    newState = userReducer(newState, completeLogout());
    expect(newState.user).toBe(null);
  });
});
