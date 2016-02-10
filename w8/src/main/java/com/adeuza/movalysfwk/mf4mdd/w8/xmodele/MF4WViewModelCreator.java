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

import com.a2a.adjava.xmodele.*;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class MF4WViewModelCreator extends MViewModelCreator {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(MViewModelCreator.class);

	/**
	 * viemodel set
	 */
	private Set<MViewModelImpl> viewModels;

	/**
	 * @param p_sName
	 * @param p_oPackage
	 * @param p_oType
	 * @param p_sTarget  le nom de l'activité/ecran associé
	 */
	public MF4WViewModelCreator(String p_sName, MPackage p_oPackage) {
		super(p_sName, p_oPackage);
		viewModels = new HashSet<>();
	}

	/**
	 * Add a screen.
	 * Screen creation must be completed.
	 *
	 * @param p_oScreen
	 */
	@Override
	public void add(MScreen p_oScreen) {
		log.debug("MViewModelCreator, add screen: {}", p_oScreen.getName());
		//this.screens.add(p_oScreen);
		addVM(p_oScreen.getViewModel());

		for (MPage oPage : p_oScreen.getPages()) {
			this.addPage(oPage);
		}

		if (p_oScreen.getViewModel() != null) {
			this.addImport(p_oScreen.getViewModel().getMasterInterface().getFullName());
			this.addImport(p_oScreen.getViewModel().getFullName());
			this.addImport(p_oScreen.getViewModel().getMasterInterface().getEntityToUpdate().getFullName());
		}
	}

	public void addVM(MViewModelImpl p_oVm) {
		this.viewModels.add(p_oVm);
	}

			/**
             * @param p_oPage
             */
	private void addPage(MPage p_oPage) {
		log.debug("MViewModelCreator.addPage: {}", p_oPage.getName());
		this.addImport(p_oPage.getViewModelImpl().getMasterInterface().getFullName());
		if (p_oPage.getViewModelImpl().getMasterInterface().getEntityToUpdate() != null) {
			this.addImport(p_oPage.getViewModelImpl().getMasterInterface().getEntityToUpdate().getFullName());
		}
		this.addImportFromSubViewModel(p_oPage.getViewModelImpl().getSubViewModels());
		this.addImportFromExternalList(p_oPage.getViewModelImpl());

		log.debug("MViewModelCreator : nb of view model {}", p_oPage.getViewModelImpl().getSubViewModels().size());
		if (p_oPage.getAdapter() != null) {
			//TODO ne devrait pas être en dur
			this.addImport("java.util.Collection");//s'il y a une adapter la création du view model se fait par une collection de données
			this.addImport("com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModel");
			this.addImport("com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.ListViewModelImpl");
		}
	}

	/**
	 * @param p_lstVmImpl
	 */
	private void addImportFromSubViewModel(List<MViewModelImpl> p_lstVmImpl) {
		for (MViewModelImpl oVm : p_lstVmImpl) {
			this.addImport(oVm.getMasterInterface().getFullName());
			this.addImport(oVm.getEntityToUpdate().getMasterInterface().getFullName());
			this.addImportFromSubViewModel(oVm.getSubViewModels());
			this.addImportFromExternalList(oVm);
		}
	}

	/**
	 * @param p_oVm
	 */
	private void addImportFromExternalList(MViewModelImpl p_oVm) {
		for (MViewModelImpl oExternalList : p_oVm.getExternalViewModels()) {
			this.addImport(oExternalList.getMasterInterface().getFullName());
			this.addImport(oExternalList.getEntityToUpdate().getMasterInterface().getFullName());
		}
	}

	/**
	 * {@inheritDoc}
	 *
	 * @see com.a2a.adjava.xmodele.SClass#toXmlInsertBeforeDocumentation(org.dom4j.Element)
	 */
	@Override
	protected void toXmlInsertBeforeDocumentation(Element p_xElement) {
		super.toXmlInsertBeforeDocumentation(p_xElement);
		Element xVms = p_xElement.addElement("vms");
		for (MViewModelImpl oVm : this.viewModels) {
			if (oVm != null) {
				xVms.add(oVm.toXml());
			}
		}
	}
}
