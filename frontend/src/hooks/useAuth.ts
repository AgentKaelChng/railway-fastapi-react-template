import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { useNavigate } from "@tanstack/react-router"

import {
  type Body_login_login_access_token as AccessToken,
  LoginService,
  type UserPublic,
  type UserRegister,
  UsersService,
} from "@/client"
import { clearAuthClientState, getCsrfToken, hasSessionHint } from "@/lib/auth"
import { handleError } from "@/utils"
import useCustomToast from "./useCustomToast"

const isLoggedIn = () => hasSessionHint()

const useAuth = () => {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { showErrorToast } = useCustomToast()

  const { data: user } = useQuery<UserPublic | null, Error>({
    queryKey: ["currentUser"],
    queryFn: UsersService.readUserMe,
    enabled: isLoggedIn(),
    retry: false,
  })

  const signUpMutation = useMutation({
    mutationFn: (data: UserRegister) =>
      UsersService.registerUser({ requestBody: data }),
    onSuccess: () => {
      navigate({ to: "/login" })
    },
    onError: (error) => handleError(showErrorToast, error),
  })

  const loginMutation = useMutation({
    mutationFn: (data: AccessToken) =>
      LoginService.loginAccessToken({ formData: data }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["currentUser"] })
      navigate({ to: "/" })
    },
    onError: (error) => handleError(showErrorToast, error),
  })

  const logoutMutation = useMutation({
    mutationFn: async () => {
      await fetch(`${import.meta.env.VITE_API_URL}/api/v1/login/logout`, {
        method: "POST",
        credentials: "include",
        headers: {
          "X-CSRF-Token": getCsrfToken() || "",
        },
      })
    },
    onSettled: () => {
      clearAuthClientState()
      queryClient.removeQueries({ queryKey: ["currentUser"] })
      navigate({ to: "/login" })
    },
  })

  const logout = () => {
    if (logoutMutation.isPending) {
      return
    }
    logoutMutation.mutate()
  }

  return {
    signUpMutation,
    loginMutation,
    logout,
    user,
  }
}

export { isLoggedIn }
export default useAuth
