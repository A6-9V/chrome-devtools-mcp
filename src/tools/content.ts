/**
 * @license
 * Copyright 2025 Google LLC
 * SPDX-License-Identifier: Apache-2.0
 */

import {z} from 'zod';

import {ToolCategories} from './categories.js';
import {defineTool} from './ToolDefinition.js';

export const getPageContent = defineTool({
  name: 'get_page_content',
  description: 'Get the HTML content of the currently selected page.',
  annotations: {
    category: ToolCategories.DEBUGGING,
    readOnlyHint: true,
  },
  schema: {
    uid: z
      .string()
      .optional()
      .describe(
        'The uid of an element on the page from the page content snapshot to get the content of. If omitted, the entire page content is returned.',
      ),
  },
  handler: async (request, response, context) => {
    if (request.params.uid) {
      const element = await context.getElementByUid(request.params.uid);
      try {
        const content = await element.evaluate((node: Element) => {
          return node.outerHTML;
        });
        response.appendResponseLine('```html');
        response.appendResponseLine(content);
        response.appendResponseLine('```');
        return;
      } finally {
        void element.dispose();
      }
    }
    const page = context.getSelectedPage();
    const content = await page.content();
    response.appendResponseLine('```html');
    response.appendResponseLine(content);
    response.appendResponseLine('```');
  },
});
