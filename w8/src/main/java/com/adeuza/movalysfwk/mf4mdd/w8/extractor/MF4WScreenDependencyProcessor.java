/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.a2a.adjava.uml.UmlDictionary;
import com.a2a.adjava.uml.UmlUsage;
import com.a2a.adjava.uml2xmodele.ui.screens.PanelAggregation;
import com.a2a.adjava.uml2xmodele.ui.screens.ScreenContext;
import com.a2a.adjava.uml2xmodele.ui.screens.ScreenDependencyProcessor;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelTypeConfiguration;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WPage;

public class MF4WScreenDependencyProcessor extends ScreenDependencyProcessor {
	
	/**
	 * Singleton instance
	 */
	private static MF4WScreenDependencyProcessor instance = new MF4WScreenDependencyProcessor();

	/**
	 * Return singleton instance
	 * @return singleton instance
	 */
	public static MF4WScreenDependencyProcessor getInstance() {
		return instance;
	}
	
	@Override
	public void treatScreenRelations(ScreenContext p_oScreenContext,
			UmlDictionary p_oUmlDict) throws Exception {
		super.treatScreenRelations(p_oScreenContext, p_oUmlDict);
		treatWorkspaceRelation(p_oScreenContext);
	}
	
	private void treatWorkspaceRelation(ScreenContext p_oScreenContext){
		IDomain<IModelDictionary, IModelFactory> oDomain = p_oScreenContext.getDomain();
		for (MScreen screen : oDomain.getDictionnary().getAllScreens()) {
			if(screen.isWorkspace()){
				
				MF4WPage masterPage = (MF4WPage)screen.getMasterPage();
				List<MPage> detailPages = new ArrayList<MPage>();
				for(MPage page: screen.getPages()){
					if(!page.equals(masterPage))
					{
						detailPages.add(page);
					}
				}
				treatNavigationDetail(masterPage, detailPages);
			}			
		}
	}
	
	@Override
	protected void treatNavigationDetailUsage(UmlUsage p_oNavigationUsage,
			List<PanelAggregation> p_listPanelAggregations, MScreen p_oScreen,
			ScreenContext p_oScreenContext) {
		// TODO Auto-generated method stub
		super.treatNavigationDetailUsage(p_oNavigationUsage, p_listPanelAggregations,
				p_oScreen, p_oScreenContext);
		IDomain<IModelDictionary, IModelFactory> oDomain = p_oScreenContext.getDomain();
		MF4WPage masterePage = (MF4WPage)p_oScreen.getMasterPage();
		MScreen oScreenEnd = oDomain.getDictionnary().getScreen(p_oNavigationUsage.getSupplier().getName());
		treatNavigationDetail(masterePage, oScreenEnd.getPages());
	}
	
	private void treatNavigationDetail(MF4WPage p_oMasterPage, List<MPage> p_oDetailPages){
		
		if(ViewModelType.LIST_1.equals(p_oMasterPage.getViewModelImpl().getType()) 
				|| ViewModelType.LIST_2.equals(p_oMasterPage.getViewModelImpl().getType()))
		{
			MVisualField visualField = findListInPage(p_oMasterPage);

			MF4WNavigationV2 navigationMasterV2 = new MF4WNavigationV2();
			navigationMasterV2.setComponentSourceName(visualField.getName());
			navigationMasterV2.setSourcePage(p_oMasterPage);
			navigationMasterV2.setType(MF4WNavigationType.MASTER_DETAIL);
			for(MPage endPage : p_oDetailPages)
			{
				MF4WPage destPage = (MF4WPage) endPage;
				MF4WNavigationV2 navigationV2 = new MF4WNavigationV2();
				navigationV2.setComponentSourceName(visualField.getName());
				navigationV2.addDestinationPage(destPage);
				navigationV2.setSourcePage(p_oMasterPage);
				navigationV2.setType(MF4WNavigationType.MASTER_DETAIL);
	
				navigationMasterV2.addDestinationPage(destPage);
				
				destPage.addReverseNavigationV2(navigationV2);
			}
			p_oMasterPage.addNavigationV2(navigationMasterV2);
		}
	}
		
	private MVisualField findListInPage(MPage p_oPage)
	{
		MVisualField result = null;
		for(MVisualField field : p_oPage.getLayout().getFields())
		{
			for(Entry<String, ViewModelTypeConfiguration> type : p_oPage.getViewModelImpl().getType().getVMTypeOptionMap().entrySet()){
				if(type.getValue().getVisualComponentName().equals(field.getComponent())){
					result = field;
					break;
				}
			}
		}
		return result;
	}
	
	public static class MF4WNavigationV2 
	{
		private MF4WPage sourcePage;
		private List<MF4WPage> destinationPage = new ArrayList<MF4WPage>();
		private String componentSourceName;
		private MF4WNavigationType type;
		
		
		
		
		public MPage getSourcePage() {
			return sourcePage;
		}
		
		public void setSourcePage(MF4WPage sourcePage) {
			this.sourcePage = sourcePage;
		}
		
		public List<MF4WPage> getDestinationPage() {
			return destinationPage;
		}
		
		public void setDestinationPage(List<MF4WPage> destinationPage) {
			this.destinationPage = destinationPage;
		}
		
		public String getComponentSourceName() {
			return componentSourceName;
		}
		
		public void setComponentSourceName(String componentSourceName) {
			this.componentSourceName = componentSourceName;
		}
		
		public MF4WNavigationType getType() {
			return type;
		}
		
		public void setType(MF4WNavigationType type) {
			this.type = type;
		}
		
		public void addDestinationPage(MF4WPage destPage){
			this.destinationPage.add(destPage);
		}
		
		/**
		 * @return
		 */
		public Element toXml() {
			Element r_xElem = DocumentHelper.createElement("navigationV2");
			r_xElem.addAttribute("type", this.type.name());
			
			Element xSource = r_xElem.addElement("source");
			xSource.addElement("component-name").setText(componentSourceName);
			xSource.addElement("component-name-lowercase").setText(componentSourceName.toLowerCase());
			xSource.addElement("component-name-capitalized").setText(StringUtils.capitalize(componentSourceName.split("__")[0]+componentSourceName.split("__")[1]));
			if(this.getSourcePage() != null && this.getSourcePage().getParent() != null){
				xSource.addElement("screen-name").setText(this.getSourcePage().getParent().getName());
			}
			return r_xElem;
		}
	} 
	
	public enum MF4WNavigationType
	{
		MASTER_DETAIL
	}
}

