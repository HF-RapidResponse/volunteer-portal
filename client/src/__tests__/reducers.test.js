import userReducer, {
  setUser,
  setRefreshTime,
  setFirstAcctPage,
  completeLogout,
} from '../../src/store/user-slice';

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
  const initialState = {
    user: null,
    firstAcctPage: null,
    tokenRefreshTime: null,
  };

  it('can load initial state', () => {
    let newState = userReducer(initialState, {});
    expect(newState).toMatchObject({});
    expect(newState.user).toBe(null);
    expect(newState.firstAcctPage).toBe(null);
    expect(newState.tokenRefreshTime).toBe(null);
  });

  it('can login and logout', () => {
    let newState = userReducer({}, setUser(testUser));

    expect(newState.user).toMatchObject(testUser);
    newState = userReducer(newState, completeLogout());
    expect(newState.user).toBe(null);
  });

  it('can set token refresh time', () => {
    const testDate = 1615764926996;
    let newState = userReducer({}, setRefreshTime(1615764926996));

    expect(newState.tokenRefreshTime).toBe(testDate);
    newState = userReducer(newState, setRefreshTime(null));
    expect(newState.tokenRefreshTime).toBe(null);
  });

  it('can set first account page', () => {
    let route = '/account/profile';
    let newState = userReducer({}, setFirstAcctPage(route));
    expect(newState.firstAcctPage).toBe(route);

    route = '/account/settings';
    newState = userReducer(newState, setFirstAcctPage(route));
    expect(newState.firstAcctPage).toBe(route);

    route = '/account/involvement';
    newState = userReducer(newState, setFirstAcctPage(route));
    expect(newState.firstAcctPage).toBe(route);

    route = '/account/data';
    newState = userReducer(newState, setFirstAcctPage(route));
    expect(newState.firstAcctPage).toBe(route);
  });

  it('can set refresh time', () => {
    let refreshTime = 1234;
    let newState = userReducer({}, setRefreshTime(refreshTime));
    expect(newState.tokenRefreshTime).toBe(refreshTime);

    refreshTime = 2345;
    newState = userReducer(newState, setRefreshTime(refreshTime));
    expect(newState.tokenRefreshTime).toBe(refreshTime);

    refreshTime = 756432;
    newState = userReducer(newState, setRefreshTime(refreshTime));
    expect(newState.tokenRefreshTime).toBe(refreshTime);
  });
});
