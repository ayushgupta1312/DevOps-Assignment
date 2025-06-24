import { render, screen, waitFor } from '@testing-library/react';
import Home from '../pages/index';
import axios from 'axios';

jest.mock('axios'); // ✅ This mocks Axios for all tests

const mockedAxios = axios as jest.Mocked<typeof axios>;

describe('Home Page', () => {
  it('renders loading text initially', () => {
    render(<Home />);
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });

  it('displays backend message and status (mocked)', async () => {
    mockedAxios.get.mockImplementation((url) => {
      if (url?.includes('/api/health')) {
        return Promise.resolve({
          data: { status: 'healthy', message: 'Backend is running successfully' }
        });
      }
      if (url?.includes('/api/message')) {
        return Promise.resolve({
          data: { message: "You've successfully integrated the backend!" }
        });
      }
      return Promise.reject(new Error("Unknown API"));
    });

    render(<Home />);

    await waitFor(() =>
      expect(screen.getByText("You've successfully integrated the backend!")).toBeInTheDocument()
    );
    expect(screen.getByText('Backend is connected!')).toBeInTheDocument();
  });
});
