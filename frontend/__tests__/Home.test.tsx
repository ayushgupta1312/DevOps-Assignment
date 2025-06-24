import { render, screen, waitFor } from '@testing-library/react';
import Home from '../pages/index';
import axios from 'axios';

jest.mock('axios');

describe('Home Page', () => {
  beforeEach(() => {
    process.env.NEXT_PUBLIC_API_URL = 'http://localhost:8000';
  });

  it('renders loading text initially', () => {
    render(<Home />);
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });

  it('displays backend message and status (mocked)', async () => {
    // Mock the API calls
    axios.get.mockImplementation((url) => {
      if (url.includes('/api/health')) {
        return Promise.resolve({ data: { status: 'healthy' } });
      } else if (url.includes('/api/message')) {
        return Promise.resolve({ data: { message: "You've successfully integrated the backend!" } });
      }
      return Promise.reject(new Error('Unknown endpoint'));
    });

    // Rendering inside waitFor to handle act() implicitly
    await waitFor(() => render(<Home />));

    await waitFor(() => {
      expect(screen.getByText("You've successfully integrated the backend!")).toBeInTheDocument();
      expect(screen.getByText('Backend is connected!')).toBeInTheDocument();
    });
  });
});
