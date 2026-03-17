const CSRF_COOKIE_NAME = "csrf_token"

export const getCookie = (name: string): string | null => {
  const encodedName = `${name}=`
  const cookies = document.cookie.split(";")
  for (const cookie of cookies) {
    const trimmed = cookie.trim()
    if (trimmed.startsWith(encodedName)) {
      return decodeURIComponent(trimmed.slice(encodedName.length))
    }
  }
  return null
}

export const clearAuthClientState = () => {
  document.cookie = `${CSRF_COOKIE_NAME}=; path=/; max-age=0`
}

export const hasSessionHint = () => Boolean(getCookie(CSRF_COOKIE_NAME))

export const getCsrfToken = () => getCookie(CSRF_COOKIE_NAME)
