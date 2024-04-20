import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'

import { MessageCreateDto } from '@interfaces'

import { Message } from '@entities/message.entity'

import { Repository } from 'typeorm'

@Injectable()
export class MessagesService {
  constructor(
    @InjectRepository(Message)
    private readonly messageRepository: Repository<Message>,
  ) {}

  async createMessage(messageCreateDto: MessageCreateDto) {
    const { message: code } = messageCreateDto
    const message = this.messageRepository.create()
    message.code = code
    const result = (await this.messageRepository.insert(message))
      .generatedMaps[0]
    return result
  }

  findAll() {
    return `This action returns all messages`
  }

  findOne(id: number) {
    return `This action returns a #${id} message`
  }
}
