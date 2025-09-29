// Minimal helper that bridges Flutter web to Razorpay Checkout JS
// Exposes: window.openRazorpay(options, successCb, errorCb)
// successCb receives: { order_id, payment_id, signature }
// errorCb receives: { code, description }
(function(){
  window.openRazorpay = function(options, successCallback, errorCallback) {
    try {
      if (typeof Razorpay === 'undefined') {
        console.error('[Razorpay Web] SDK not loaded');
        if (typeof errorCallback === 'function') {
          errorCallback({ code: 'SDK_NOT_LOADED', description: 'Razorpay SDK not loaded' });
        }
        return;
      }

      // Normalize options: support key_id alias, and attach handler for success
      if (!options) options = {};
      if (!options.key && options.key_id) {
        options.key = options.key_id;
      }
      if (!options.key) {
        if (typeof window !== 'undefined' && window.__RZP_PUBLIC_KEY) {
          options.key = window.__RZP_PUBLIC_KEY;
        }
      }
      if (!options.key) {
        console.error('[Razorpay Web] missing options.key (after normalization). window.__RZP_PUBLIC_KEY=', (typeof window !== 'undefined' ? window.__RZP_PUBLIC_KEY : undefined));
      }

      options.handler = function(resp) {
        try {
          var payload = {
            order_id: resp.razorpay_order_id,
            payment_id: resp.razorpay_payment_id,
            signature: resp.razorpay_signature
          };
          successCallback && successCallback(payload);
        } catch (e) {
          console.error('[Razorpay Web] success handler error', e);
        }
      };
      options.modal = options.modal || {};
      options.modal.ondismiss = function(){
        try {
          errorCallback && errorCallback({ code: 'DISMISSED', description: 'Checkout closed by user' });
        } catch (e) {
          console.error('[Razorpay Web] dismiss handler error', e);
        }
      };

      console.log('[Razorpay Web] options:', options);
      var rzp = new Razorpay(options);

      // Keep event listeners as a fallback
      rzp.on('payment.success', function(resp){
        try {
          var payload = {
            order_id: resp.razorpay_order_id,
            payment_id: resp.razorpay_payment_id,
            signature: resp.razorpay_signature
          };
          successCallback && successCallback(payload);
        } catch (e) {
          console.error('[Razorpay Web] success handler error', e);
        }
      });

      rzp.on('payment.error', function(resp){
        try {
          var err = (resp && resp.error) || resp || {};
          errorCallback && errorCallback({ code: err.code, description: err.description });
        } catch (e) {
          console.error('[Razorpay Web] error handler error', e);
        }
      });

      rzp.open();
    } catch (e) {
      console.error('[Razorpay Web] open error', e);
      if (typeof errorCallback === 'function') {
        errorCallback({ code: 'EXCEPTION', description: e && e.message ? e.message : 'Unknown error' });
      }
    }
  };
})();
