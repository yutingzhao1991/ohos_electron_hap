/*
 * Copyright (c) 2023-2025 Haitai FangYuan Co., Ltd.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of
 *    conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list
 *    of conditions and the following disclaimer in the documentation and/or other materials
 *    provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used
 *    to endorse or promote products derived from this software without specific prior written
 *    permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { StartOptions, Want } from '@kit.AbilityKit';
import LogUtil from './LogUtil';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'LaunchHelper';

export default class LaunchHelper {
  static LaunchWithOptions(uiContext: Context | undefined,
                           want: Want,
                           options: StartOptions): boolean {
    try {
      let context = uiContext as common.UIAbilityContext ||
        uiContext as common.UIExtensionContext;
      if (!context) {
        LogUtil.error(TAG, `excute failed, want: ${JSON.stringify(want)}, options:  ${JSON.stringify(options)}`);
        return false;
      }
      context.startAbility(want, options)
        .catch((error: BusinessError) => {
        LogUtil.error(TAG, `excute failed. Cause: ${JSON.stringify(error)}`);
        return false;
      });
    } catch (exception) {
      LogUtil.error(TAG, `excute failed exception. Cause: ${JSON.stringify(exception)}`);
      return false;
    }
    return true;
  }

  static Launch(uiContext: Context | undefined, want: Want): boolean {
    return LaunchHelper.LaunchWithOptions(uiContext, want, {});
  }

  /**
   * 不带 StartOptions 启动新实例。StartOptions.processMode 只对状态栏组件开放：
   * ATTACH_TO_STATUS_BAR_ITEM 会被 AMS 以 "not in status bar" 拒绝（16000067），
   * NEW_PROCESS_ATTACH_TO_PARENT 会被以 "processMode is not attach to status bar item"
   * 拒绝（16000068），而省略 processMode 又会在 napi 层 "Unwrap processMode failed"（401）。
   * 因此普通应用的独立窗口必须走单参 startAbility，窗口几何信息通过 want.parameters 传递。
   */
  static LaunchWithoutOptions(uiContext: Context | undefined, want: Want): boolean {
    try {
      let context = uiContext as common.UIAbilityContext ||
        uiContext as common.UIExtensionContext;
      if (!context) {
        LogUtil.error(TAG, `excute failed, want: ${JSON.stringify(want)}`);
        return false;
      }
      context.startAbility(want)
        .catch((error: BusinessError) => {
          LogUtil.error(TAG, `excute failed. Cause: ${JSON.stringify(error)}`);
          return false;
        });
    } catch (exception) {
      LogUtil.error(TAG, `excute failed exception. Cause: ${JSON.stringify(exception)}`);
      return false;
    }
    return true;
  }
}
