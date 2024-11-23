<template>
  <footer :class="footerClass" class="footer">
    <div class="footer-content">
      <span>© MinSU MindConnect App</span>
    </div>
    <div class="help-center">
      <router-link to="/help-center" class="nav-link">
        <i class="fas fa-info-circle"></i>
        <span class="link-text">FAQs</span>
      </router-link>
    </div>
  </footer>
</template>

<script>
export default {
  name: "Footer",
  data() {
    return {
      isScrolling: false,
      footerClass: "footer",
    };
  },
  mounted() {
    let timeout;
    window.addEventListener("scroll", () => {
      // Start shrinking the footer when scrolling begins
      if (!this.isScrolling) {
        this.isScrolling = true;
        this.footerClass = "footer shrinking";
      }

      // Reset the timeout to detect when scrolling stops
      clearTimeout(timeout);
      timeout = setTimeout(() => {
        this.isScrolling = false;
        this.footerClass = "footer"; // Reset the footer size when scrolling stops
      }, 150); // Adjust this timeout as necessary (in ms)
    });
  },
};
</script>

<style scoped>
.footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f8f9fa;
  padding: 10px 20px;
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  border-top: 1px solid #ddd;
  transition: padding 0.3s, transform 0.3s ease;
  z-index: 1000; /* Ensures the footer stays above other content */
}

.shrinking {
  padding: 5px 20px; /* Shrink footer's padding when scrolling */
  transform: translateY(10px); /* Optionally move footer slightly up */
}

.footer-content {
  color: #555;
}

.help-center {
  display: flex;
  align-items: center;
  margin-right: 5rem;
}

.nav-link {
  display: flex;
  align-items: center;
  color: #2a9d8f;
  text-decoration: none;
  transition: color 0.2s ease;
}

.nav-link:hover {
  color: #176c5a;
}

.nav-link i {
  margin-right: 5px;
}

.link-text {
  font-size: 14px;
}
</style>
