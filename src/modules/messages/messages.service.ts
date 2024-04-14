import { Injectable } from '@nestjs/common'

import { UserRepository } from '@repositories/message.repository'

@Injectable()
export class MessagesService {
  constructor() {}

  create() {
    return 'This action adds a new message'
  }

  findAll() {
    return `This action returns all messages`
  }

  findOne(id: number) {
    return `This action returns a #${id} message`
  }

  update(id: number) {
    return `This action updates a #${id} message`
  }

  remove(id: number) {
    return `This action removes a #${id} message`
  }
}
