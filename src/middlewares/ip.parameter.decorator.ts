import { ExecutionContext, createParamDecorator } from '@nestjs/common'

export const IPv4 = createParamDecorator(
  (data: undefined, ctx: ExecutionContext): string => {
    const request = ctx.switchToHttp().getRequest()
    const ip = request.ip

    // Check for ::ffff: prefix and remove it if present
    if (ip.startsWith('::ffff:')) {
      return ip.substring(7)
    }
    return ip
  },
)
