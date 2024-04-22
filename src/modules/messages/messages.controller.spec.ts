import { INestApplication } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { Test, TestingModule } from '@nestjs/testing'
import { TypeOrmModule } from '@nestjs/typeorm'

import { TypeOrmConfigService } from '@configs/typeorm.config.service'

import { Message } from '@entities/message.entity'

import { MessagesController } from '@messages/messages.controller'
import { MessagesService } from '@messages/messages.service'

describe('MessagesController', () => {
  let controller: MessagesController
  let app: INestApplication

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          isGlobal: true,
          envFilePath: `.env.${process.env.NODE_ENV}`,
        }),
        TypeOrmModule.forRootAsync({
          imports: [ConfigModule],
          useClass: TypeOrmConfigService,
        }),
        TypeOrmModule.forFeature([Message]),
      ],
      controllers: [MessagesController],
      providers: [MessagesService],
    }).compile()

    controller = module.get<MessagesController>(MessagesController)
    app = module.createNestApplication()
  })

  it('should be defined', () => {
    expect(controller).toBeDefined()
  })

  afterAll(async () => {
    await app.close()
  })
})
