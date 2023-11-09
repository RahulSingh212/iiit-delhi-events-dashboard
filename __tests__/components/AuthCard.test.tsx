import React from 'react';
import { render, screen } from '@testing-library/react';
import {AuthCard} from '@/components/AuthCard'; // Import your component

describe('AuthCard Component', () => {
  it('should render the component', () => {
    render(<AuthCard />);
    
    // Check that the component is rendered
    const authCardElement = screen.getByTestId('auth-card');
    expect(authCardElement).not.toBeNull();

    // Check for specific elements you want to test
    const loginText = screen.queryByText(/Log-in/i);
    const selectUserTypeLabel = screen.queryByText(/Select User Type:/i);

    expect(loginText).not.toBeNull();
    expect(selectUserTypeLabel).not.toBeNull();

    // You can add more assertions to check for other elements if needed
  });
});
