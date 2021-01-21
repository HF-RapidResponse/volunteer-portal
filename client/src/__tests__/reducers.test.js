import userReducer, { login, logout } from '../store/user-slice.js';

describe('user reducer', () => {
  const testUser = {
    userID: '123456',
    name: 'Bob Saget',
    email: 'test@test.com',
    picture: 'https://via.placeholder.com/300/09f/fff.png',
  };

  it('can login and logout', () => {
    let newState = userReducer({}, login(testUser));

    expect(newState.user).toMatchObject(testUser);
    newState = userReducer(newState, logout());
    expect(newState.user).toBe(null);
  });
});
