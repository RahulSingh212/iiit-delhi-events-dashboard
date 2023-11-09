import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import { NewClub } from "../../components/NewClub";

describe("NewClub Component", () => {
  test("renders the NewClub component", () => {
    render(<NewClub />);
    
    // Check if the "Club Name" title is present in the rendered component
    const clubNameTitle = screen.getByText("Club Name");
    expect(clubNameTitle).toBeDefined();
    
    // Check if the input element is present in the rendered component
    const inputElement = screen.getByPlaceholderText("Enter the name of the club");
    expect(inputElement).toBeDefined();
  });

  test("updates club name when input value changes", () => {
    render(<NewClub />);
    
    // Find the input element
    const inputElement = screen.getByPlaceholderText("Enter the name of the club") as HTMLInputElement;

    // Simulate changing the input value
    fireEvent.change(inputElement, { target: { value: "My Club" } });

    // Verify that the input value has been updated
    expect(inputElement.value).toBe("My Club");
  });
});
