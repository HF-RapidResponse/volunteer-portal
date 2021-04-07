import userReducer, { updateInitiativeMap } from 'store/user-slice';
import axios from 'axios';
import { mockInitiatives } from '../__mocks__/api-data';

jest.mock('axios');
console.log = jest.fn();
console.error = jest.fn();

describe('updateInitiativeMap function', () => {
  it('can populate an existing initiative map with new values', async () => {
    axios.get.mockImplementationOnce(() =>
      Promise.resolve({ data: mockInitiatives })
    );
    const currentMap = { 'Seth Pollard': true };
    const updatedMap = await updateInitiativeMap(currentMap);

    expect(updatedMap).toBeDefined();
    expect(updatedMap['Danielle Thomas']).toBe(false);
    expect(updatedMap['Seth Pollard']).toBe(true);
    expect(updatedMap['Matthew Smith']).toBe(false);
  });

  it('can populate an empty initiative map with new values', async () => {
    axios.get.mockImplementationOnce(() =>
      Promise.resolve({ data: mockInitiatives })
    );
    const currentMap = null;
    const updatedMap = await updateInitiativeMap(currentMap);

    expect(updatedMap).toBeDefined();
    expect(updatedMap['Danielle Thomas']).toBe(false);
    expect(updatedMap['Seth Pollard']).toBe(false);
    expect(updatedMap['Matthew Smith']).toBe(false);
  });

  it('can leave an initiative map alone if it already contains updated values', async () => {
    axios.get.mockImplementationOnce(() =>
      Promise.resolve({ data: mockInitiatives })
    );
    const currentMap = {
      'Danielle Thomas': false,
      'Seth Pollard': true,
      'Matthew Smith': true,
    };
    const updatedMap = await updateInitiativeMap(currentMap);

    expect(updatedMap).toBeDefined();
    expect(updatedMap).toMatchObject(currentMap);
  });

  it('can return an empty object if the initiatives API endpiont returns an empty array', async () => {
    axios.get.mockImplementationOnce(() => Promise.resolve({ data: [] }));
    const currentMap = {
      'Danielle Thomas': false,
      'Seth Pollard': true,
      'Matthew Smith': true,
    };
    const updatedMap = await updateInitiativeMap(currentMap);

    expect(updatedMap).toBeDefined();
    expect(updatedMap).toMatchObject({});
  });

  it('can return the input payload if the initiatives API endpoint throws an error', async () => {
    axios.get.mockImplementationOnce(() => Promise.reject('some mock error'));
    const currentMap = {
      'Danielle Thomas': false,
      'Seth Pollard': true,
      'Matthew Smith': true,
    };
    const updatedMap = await updateInitiativeMap(currentMap);

    expect(updatedMap).toBeDefined();
    expect(updatedMap).toMatchObject(currentMap);
  });

  it('can return an empty object if the input payload is null and the initiatives API endpoint throws an error', async () => {
    axios.get.mockImplementationOnce(() => Promise.reject('some mock error'));
    const currentMap = null;
    const updatedMap = await updateInitiativeMap(currentMap);

    expect(updatedMap).toBeDefined();
    expect(updatedMap).toMatchObject({});
  });
});
