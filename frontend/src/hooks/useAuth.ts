import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { useNavigate } from "@tanstack/react-router"

import {
  type Body_login_login_access_token as AccessToken,
  LoginService,
  type UserPublic,
  type UserRegister,
  UsersService,
} from "@/client"
import { handleError } from "@/utils"
import useCustomToast from "./useCustomToast"

type JwtPayload = {
  exp?: number
}

const parseJwtPayload = (token: string): JwtPayload | null => {
  const parts = token.split(".")
  if (parts.length !== 3) {
    return null
  }

  try {
    const payload = parts[1]
      .replace(/-/g, "+")
      .replace(/_/g, "/")
      .padEnd(Math.ceil(parts[1].length / 4) * 4, "=")
    return JSON.parse(window.atob(payload)) as JwtPayload
  } catch {
    return null
  }
}

const isLoggedIn = () => {
  const token = localStorage.getItem("access_token")
  if (!token) {
    return false
  }

  const payload = parseJwtPayload(token)
  if (!payload?.exp) {
    localStorage.removeItem("access_token")
    return false
  }

  const nowInSeconds = Math.floor(Date.now() / 1000)
  if (payload.exp <= nowInSeconds) {
    localStorage.removeItem("access_token")
    return false
  }

  return true
}

const useAuth = () => {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { showErrorToast } = useCustomToast()

  const { data: user } = useQuery<UserPublic | null, Error>({
    queryKey: ["currentUser"],
    queryFn: UsersService.readUserMe,
    enabled: isLoggedIn(),
  })

  const signUpMutation = useMutation({
    mutationFn: (data: UserRegister) =>
      UsersService.registerUser({ requestBody: data }),
    onSuccess: () => {
      navigate({ to: "/login" })
    },
    onError: (error) => handleError(showErrorToast, error),
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] })
    },
  })

  const login = async (data: AccessToken) => {
    const response = await LoginService.loginAccessToken({
      formData: data,
    })
    localStorage.setItem("access_token", response.access_token)
  }

  const loginMutation = useMutation({
    mutationFn: login,
    onSuccess: () => {
      navigate({ to: "/" })
    },
    onError: (error) => handleError(showErrorToast, error),
  })

  const logout = () => {
    localStorage.removeItem("access_token")
    navigate({ to: "/login" })
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
