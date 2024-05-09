export const isLocal = () => process.env.NODE_ENV === 'local'

export const isProd = () => process.env.NODE_ENV === 'production'
