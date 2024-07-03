import { Injectable, NestMiddleware } from '@nestjs/common'

import { NextFunction, Request, Response } from 'express'

@Injectable()
export class IpMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const ip = req.ip
    // Check for ::ffff: prefix and remove it if present
    if (ip.startsWith('::ffff:')) {
      req.ip = ip.substring(7)
    }
    next()
  }
}
