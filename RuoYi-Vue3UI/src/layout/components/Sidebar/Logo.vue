<template>
  <div class="sidebar-logo-container" :class="{ 'collapse': collapse }">
    <router-link class="sidebar-logo-link" to="/" :title="fullTitle">
      <span class="logo-mark" aria-hidden="true">
        <svg viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id="sidebarLogoGrad" x1="0" y1="0" x2="1" y2="1">
              <stop offset="0" stop-color="#30B08F" />
              <stop offset="1" stop-color="#409EFF" />
            </linearGradient>
          </defs>
          <rect x="1" y="1" width="38" height="38" rx="11" fill="url(#sidebarLogoGrad)" />
          <path d="M8 21.5h6.2l2.6-7 4.6 12.5 2.8-5.5H32" fill="none" stroke="#ffffff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </span>
      <span v-show="!collapse" class="logo-text">
        <span class="logo-title">校园体检 · 健康档案</span>
        <span class="logo-subtitle">学生健康管理系统</span>
      </span>
    </router-link>
  </div>
</template>

<script setup>
import useSettingsStore from '@/store/modules/settings'
import variables from '@/assets/styles/variables.module.scss'

defineProps({
  collapse: {
    type: Boolean,
    required: true
  }
})

const fullTitle = import.meta.env.VITE_APP_TITLE
const settingsStore = useSettingsStore()
const sideTheme = computed(() => settingsStore.sideTheme)

// 获取Logo背景色
const getLogoBackground = computed(() => {
  if (settingsStore.isDark) {
    return 'var(--sidebar-bg)'
  }
  if (settingsStore.navType == 3) {
    return variables.menuLightBg
  }
  return sideTheme.value === 'theme-dark' ? variables.menuBg : variables.menuLightBg
})

// 获取Logo文字颜色
const getLogoTextColor = computed(() => {
  if (settingsStore.isDark) {
    return 'var(--sidebar-logo-text)'
  }
  if (settingsStore.navType == 3) {
    return variables.menuLightText
  }
  return sideTheme.value === 'theme-dark' ? '#fff' : variables.menuLightText
})

// Logo 与菜单之间的分隔线颜色
const getLogoBorderColor = computed(() => {
  const dark = settingsStore.isDark || (settingsStore.navType != 3 && sideTheme.value === 'theme-dark')
  return dark ? 'rgba(255, 255, 255, 0.07)' : 'rgba(0, 0, 0, 0.06)'
})
</script>

<style lang="scss" scoped>
/* 前缀提升优先级：覆盖 sidebar.scss 中 #app .sidebar-container a 的 inline-block */
#app .sidebar-container .sidebar-logo-container {
  position: relative;
  height: 50px;
  background: v-bind(getLogoBackground);
  border-bottom: 1px solid v-bind(getLogoBorderColor);
  overflow: hidden;

  .sidebar-logo-link {
    display: flex;
    align-items: center;
    height: 100%;
    width: 100%;
    padding: 0 12px;
    box-sizing: border-box;
    text-decoration: none;

    .logo-mark {
      flex: none;
      display: inline-flex;
      width: 32px;
      height: 32px;

      svg {
        width: 100%;
        height: 100%;
        filter: drop-shadow(0 2px 6px rgba(64, 158, 255, 0.35));
      }
    }

    .logo-text {
      display: flex;
      flex-direction: column;
      justify-content: center;
      margin-left: 10px;
      overflow: hidden;
      line-height: 1.2;
      font-family: 'PingFang SC', 'Microsoft YaHei', Avenir, 'Helvetica Neue', Arial, sans-serif;

      .logo-title {
        color: v-bind(getLogoTextColor);
        font-size: 14px;
        font-weight: 600;
        letter-spacing: 0.3px;
        white-space: nowrap;
      }

      .logo-subtitle {
        margin-top: 2px;
        color: v-bind(getLogoTextColor);
        opacity: 0.5;
        font-size: 10px;
        letter-spacing: 1.5px;
        white-space: nowrap;
      }
    }
  }

  &.collapse .sidebar-logo-link {
    justify-content: center;
    padding: 0;
  }
}
</style>