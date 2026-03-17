import { AxiosError } from "axios"
import type { ApiError } from "./client"

type ApiErrorBody = {
  detail?: string | Array<{ msg?: string }>
}

function extractErrorMessage(err: ApiError): string {
  if (err instanceof AxiosError) {
    return err.message
  }

  const errDetail = (err.body as ApiErrorBody | undefined)?.detail
  if (Array.isArray(errDetail) && errDetail.length > 0) {
    return errDetail[0].msg || "Something went wrong."
  }
  return errDetail || "Something went wrong."
}

export const handleError = (
  showError: (msg: string) => void,
  err: ApiError,
) => {
  const errorMessage = extractErrorMessage(err)
  showError(errorMessage)
}

export const getInitials = (name: string): string => {
  return name
    .split(" ")
    .slice(0, 2)
    .map((word) => word[0])
    .join("")
    .toUpperCase()
}
