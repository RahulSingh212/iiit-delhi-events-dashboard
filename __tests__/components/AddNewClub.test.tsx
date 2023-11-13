// File: AddNewClub.test.tsx

import { render, screen, fireEvent, act } from "@testing-library/react";
import { AddNewClub } from "../../components/AddNewClub";
import { createNewIndependentClubHandler } from "@/lib/firebase/clubsHandler";

// Mock the next/router module
jest.mock("next/router", () => ({
  useRouter: jest.fn(),
}));

// Mock the createNewIndependentClubHandler function
jest.mock("../../lib/firebase/clubsHandler.ts", () => ({
  createNewIndependentClubHandler: jest.fn(),
}));

describe("AddNewClub Component", () => {
  it("should submit the form and navigate to /clubs on success", async () => {
    // Mock useRouter implementation
    const useRouterMock = jest.requireMock("next/router").useRouter;
    useRouterMock.mockReturnValue({
      replace: jest.fn(),
    });

    // Mock createNewIndependentClubHandler implementation
    const createNewIndependentClubHandlerMock = jest.requireMock(
      "../../lib/firebase/clubsHandler.ts"
    ).createNewIndependentClubHandler;
    createNewIndependentClubHandlerMock.mockResolvedValue({
      status: true,
      message: "Club added successfully",
    });

    // Mock window.alert
    const originalAlert = window.alert;
    window.alert = jest.fn();

    // Render the component
    render(<AddNewClub />);

    // Fill in form data
    fireEvent.change(
      screen.getByPlaceholderText(/Enter the name of the club/i),
      { target: { value: "Test Club" } }
    );
    fireEvent.change(
      screen.getByPlaceholderText(/Enter the description of the club/i),
      { target: { value: "Test Description" } }
    );
    fireEvent.change(
      screen.getByPlaceholderText(/Enter the email-id of admin of the club/i),
      { target: { value: "admin@example.com" } }
    );
    fireEvent.change(
      screen.getByPlaceholderText(/Enter the image url of the club/i),
      {
        target: {
          value:
            "https://th.bing.com/th/id/R.35b7cf10203ae316c59e65b9f0c6d60d?rik=PEZxCxVcGh5lEw&riu=http%3a%2f%2fs1.picswalls.com%2fwallpapers%2f2017%2f12%2f11%2fnature-desktop-background_123026895_313.jpg&ehk=rvr98svQL12hNeYouWPK7AvyXVnHaRJWDvovllsJxRs%3d&risl=1&pid=ImgRaw&r=0",
        },
      }
    );

    // Trigger form submission
    fireEvent.click(screen.getByText(/Add Club/i));

    // Wait for asynchronous operations to complete
    await act(async () => {
      // Assert that createNewIndependentClubHandler was called with the correct parameters
      expect(createNewIndependentClubHandlerMock).toHaveBeenCalledWith(
        expect.objectContaining({
          club_Name: "Test Club",
          club_Description: "Test Description",
          club_Logo_Url:
            "https://th.bing.com/th/id/R.35b7cf10203ae316c59e65b9f0c6d60d?rik=PEZxCxVcGh5lEw&riu=http%3a%2f%2fs1.picswalls.com%2fwallpapers%2f2017%2f12%2f11%2fnature-desktop-background_123026895_313.jpg&ehk=rvr98svQL12hNeYouWPK7AvyXVnHaRJWDvovllsJxRs%3d&risl=1&pid=ImgRaw&r=0",
        }),
        "admin@example.com"
      );
    });

    // Restore the original window.alert
    window.alert = originalAlert;
  });

  // Add more test cases as needed
});
