import { render, screen } from '@testing-library/react';
import HomePage from '../../pages/index';

describe('HomePage', () => {
  it('renders the home page with the correct content', () => {
    render(<HomePage />);

    // Use screen queries to assert the presence of specific elements or text
    const headingElement = screen.getByText(/home/i);

    // Add more assertions as needed
    expect(headingElement).toBeDefined();
    // Or use other matchers like `toBeTruthy()`, `not.toBeNull()`, etc., based on your preference

    // Alternatively, you can also use vanilla JavaScript assertions
    // For example:
    // const headingElement = screen.getByText(/home/i);
    // if (headingElement) {
    //   // Perform assertions
    //   expect(headingElement.textContent).toBe('Home');
    // } else {
    //   // Fail the test if the element is not found
    //   fail('Heading element not found');
    // }
  });
});
