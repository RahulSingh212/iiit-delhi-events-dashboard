import React from 'react';
import { render } from '@testing-library/react';
import HomePage from '../../pages/index'; // Replace with your actual file path

test('renders the HomePage component', () => {
  const { container } = render(<HomePage />);

  // You can access the container element and make assertions about its content.
  // For example, let's check if it contains the "Home" text.
  expect(container.innerHTML).toContain('Home');
  
  // You can add more assertions as needed.
});
