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

  async createMessage(
    location: string,
    messageCreateDto: MessageCreateDto,
  ): Promise<Message> {
    const { message: code } = messageCreateDto
    const message = this.messageRepository.create()
    message.code = code
    message.location = location
    const result = (await this.messageRepository.insert(message))
      .generatedMaps[0] as Message
    result.code = code
    result.location = location
    return result
  }

  async findMessages(): Promise<Message[]> {
    const queryBuilder = this.messageRepository
      .createQueryBuilder()
      .select()
      .orderBy('RAND()')
      .limit(20)
    return await queryBuilder.getMany()
  }
}
