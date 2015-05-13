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
package com.adeuza.movalysfwk.mf4mdd.w8.xmodele;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import org.dom4j.Element;

import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.xmodele.MAdapter;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.adeuza.movalysfwk.mf4mdd.w8.extractor.MF4WScreenDependencyProcessor.MF4WNavigationV2;

public class MF4WPage extends MPage{
	
	/**
	 * Screen layout
	 */
	private MLayout searchLayout ;
	
	/**
	 * true if a chained save action is created on the screen including the page
	 */
	private boolean hasChainedSaveAction = false;
	
	/**
	 * true if a chained save action is created on the screen including the page
	 */
	private boolean hasChainedDeleteAction = false;

	public MF4WPage(MScreen p_oParent, String p_sPageName, UmlClass p_oUmlPage,
			MPackage p_oPackage, MViewModelImpl p_oVmImpl, boolean p_bTitled) {
		super(p_oParent, p_sPageName, p_oUmlPage, p_oPackage, p_oVmImpl, p_bTitled);
	}


	@Override
	public void addExternalAdapter(MAdapter p_oAdapter, String p_sComponentName) {
		super.addExternalAdapter(p_oAdapter, p_sComponentName);
		if(p_oAdapter != null)
		{
			List<MLayout> layouts = new ArrayList<MLayout>();
			for(Entry<String, MAdapter> adapter : externalAdapters.entrySet())
			{
				layouts.addAll(adapter.getValue().getLayouts());
			}
			for(MLayout layout : layouts)
			{
				for(Entry<String, MAdapter> adapter : externalAdapters.entrySet())
				{
					layout.setExternalAdapters(new WeakReference<MAdapter>(adapter.getValue()));
				}
			}
		}
	}
	
	@Override
	public void setAdapter(MAdapter p_oAdapter) {
		super.setAdapter(p_oAdapter);
		if(p_oAdapter != null)
		{
			List<MLayout> layouts = new ArrayList<MLayout>();
			layouts.addAll(p_oAdapter.getLayouts());
			for(MLayout layout : layouts)
			{
				layout.setAdapter(p_oAdapter);
			}
		}
	}
	
	public MLayout getSearchLayout() {
		return searchLayout;
	}

	public void setSearchLayout(MLayout searchLayout) {
		this.searchLayout = searchLayout;
	}
	
	
	public boolean hasChainedSaveAction() {
		return hasChainedSaveAction;
	}


	public void setHasChainedSaveAction(boolean hasChainedSaveAction) {
		this.hasChainedSaveAction = hasChainedSaveAction;
	}
	
	public boolean hasChainedDeleteAction() {
		return hasChainedDeleteAction;
	}


	public void setHasChainedDeleteAction(boolean hasChainedDeleteAction) {
		this.hasChainedDeleteAction = hasChainedDeleteAction;
	}


	/**
	 * Navigation V2
	 */
	private List<MF4WNavigationV2> navigationsV2 = new ArrayList<MF4WNavigationV2>();
	
	/**
	 * Reverse Navigation V2
	 */
	private List<MF4WNavigationV2> reverseNavigationsV2 = new ArrayList<MF4WNavigationV2>();
	
	

	/**
	 * @param p_oNavigationV2
	 */
	public void addNavigationV2( MF4WNavigationV2 p_oNavigation ) {
		this.navigationsV2.add(p_oNavigation);
	}
	/**
	 * @param p_oNavigationV2
	 */
	public void addReverseNavigationV2( MF4WNavigationV2 p_oNavigation ) {
		this.reverseNavigationsV2.add(p_oNavigation);
	}
	

	/**
	 * @param p_oNavigation
	 */
	public List<MF4WNavigationV2> getNavigationV2() {
		return this.navigationsV2;
	}	/**
	 * @param p_oNavigation
	 * @return 
	 */
	public List<MF4WNavigationV2> getReverseNavigationV2() {
		return this.reverseNavigationsV2;
	}
	
	@Override
	protected void toXmlInsertBeforeDocumentation(Element p_xElement) {
		super.toXmlInsertBeforeDocumentation(p_xElement);
		
		
		Element xNavs = p_xElement.addElement("navigationsV2");
		for( MF4WNavigationV2 oNavigation : this.navigationsV2 ) {
			xNavs.add(oNavigation.toXml());
		}
		
		
		xNavs = p_xElement.addElement("reverse-navigationsV2");
		for( MF4WNavigationV2 oNavigation : this.reverseNavigationsV2 ) {
			xNavs.add(oNavigation.toXml());
		}
		
		if (this.searchLayout != null) {
			p_xElement.addElement("search-template").setText(this.searchLayout.getName());
		}
		
		if (this.hasChainedSaveAction) {
			p_xElement.addElement("chained-save").setText("true");
		}
		
		if (this.hasChainedDeleteAction) {
			p_xElement.addElement("chained-delete").setText("true");
		}
	}
}
