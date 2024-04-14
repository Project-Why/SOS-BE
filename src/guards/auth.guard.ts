import { CanActivate, Injectable } from '@nestjs/common'

@Injectable()
export class AuthGuard implements CanActivate {
  canActivate() {
    console.log('기본 인증이 성공하였습니다.')
    return true
  }
}
