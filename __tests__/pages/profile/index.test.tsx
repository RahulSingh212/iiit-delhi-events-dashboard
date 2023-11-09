import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { userLogoutHandler } from "@/lib/firebase/userHandler";
import ProfilePage from "../../../pages/profile/index"; // Adjust the import path accordingly

// Mock the useRouter hook
jest.mock("next/router", () => ({
    useRouter: () => ({
      push: jest.fn(),
    }),
  }));
  
  describe("ProfilePage", () => {
    it("renders ProfilePage component", () => {
      render(<ProfilePage />);
      const profileHeader = screen.getByText("Profile");
      const logoutButton = screen.getByText("Logout");
  
      expect(profileHeader).toBeTruthy();
      expect(logoutButton).toBeTruthy();
    });

  });