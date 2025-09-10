# Vars
CC      = gcc
CFLAGS  = -Wall -g -MMD -MP     # -MMD -MP 自动生成 .d
SRC     = $(wildcard *.c)
OBJ_DIR = build
OBJ     = $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRC))
TARGET  = program

.PHONY: all clean run

all: $(TARGET)

# 链接
$(TARGET): $(OBJ)
	$(CC) -o $@ $^

# 编译（使用 order-only 依赖保证目录存在）
$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# 目录生成规则（不是把 "build" 当命令执行）
$(OBJ_DIR):
	mkdir -p $@

# 自动包含依赖
-include $(OBJ:.o=.d)

clean:
	rm -rf $(OBJ_DIR) $(TARGET)

run: all
	./$(TARGET) main.lox
