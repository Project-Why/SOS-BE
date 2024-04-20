import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'

import { Message } from '@entities/message.entity'

import { MessagesController } from '@messages/messages.controller'
import { MessagesService } from '@messages/messages.service'

@Module({
  imports: [TypeOrmModule.forFeature([Message])],
  controllers: [MessagesController],
  providers: [MessagesService],
})
export class MessagesModule {}
