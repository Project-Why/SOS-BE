import { ExecutionContext, createParamDecorator } from '@nestjs/common'

import { Request } from 'express'

export const IPv4 = createParamDecorator(
  (data: undefined, ctx: ExecutionContext): string => {
    const request = ctx.switchToHttp().getRequest<Request>()
    const xForwardedFor = request.headers['x-forwarded-for'] as string
    let ip = request.ip

    if (xForwardedFor) {
      const forwardedIps = xForwardedFor.split(',')
      ip = forwardedIps[0].trim()
    }

    // Check for ::ffff: prefix and remove it if present
    if (ip.startsWith('::ffff:')) {
      return ip.substring(7)
    }
    return ip
  },
)
